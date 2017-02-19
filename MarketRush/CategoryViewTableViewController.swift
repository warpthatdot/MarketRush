//
//  CategoryViewTableViewController.swift
//  MarketRush
//
//  Created by Sarah Yoon on 2017. 2. 15..
//  Copyright © 2017년 Sarah Yoon. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

// 대분류: 신선식품, 가공식품
// 중분류: 신선식품[야채, 과일, 곡류, 육류, 빵, 음료]
//       가공식품[견과류, 면류/쌀, 유제품, 소스류/오일류]
// search bar 추가
// 음성인식 api 추가

class CategoryViewTableViewController: UITableViewController {

    //Section
    var sections = ["오늘의 상품", "신선식품", "가공식품"]
    var categoryList = [["최신상품"],["야채", "과일", "곡류", "육류", "빵", "음료"],["유제품", "견과류", "면류/쌀", "소스류/오일류"]]
    
    //카테고리별 제목 배열
    var categoryTitle:[[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTitle = [[],["야채", "과일", "곡류", "육류", "빵", "음료"],["유제품", "견과류", "면류/쌀", "소스류/오일류"]]
        
        //add observer for product api calls
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveProductInfo(noti:)), name: DidReceiveProductInfo, object: nil)
        
        //오늘의 상품 api 호출 (식품)
        callProductApi(query: "식품", start: 2, display: 20)
        
        
    }
    
    //remove observer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: DidReceiveProductInfo, object: nil)
    }
    
    //
    func didReceiveProductInfo(noti: Notification) {
        self.tableView.reloadSections(IndexSet([0]), with: UITableViewRowAnimation.automatic)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //section별 row 갯수
        switch section
        {
        case 0:
            
            return categoryList[0].count
            
        case 1:
            
            return categoryList[1].count
            
        case 2:
            
            return categoryList[2].count
            
        default:
            NSLog("no count")
            return 1
            
        }
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
            
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayProductCell", for: indexPath) as! TodayProductTableViewCell
            cell.todayProductCollectionView.reloadData()
           
            return cell
        }
            
        //신선식품 section
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            cell.categoryTitle?.text = categoryTitle[1][indexPath.row]
            
            return cell
            
        }
            
        //가공식품 section
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            cell.categoryTitle?.text = categoryTitle[2][indexPath.row]
            return cell
            
        }
    }
 
    //tablecell별 높이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 160
        }
            
        else{
            return 70
        }
        
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //해당카테고리로 이동하면서 관련 타이틀 갖고가기
        if(segue.identifier == "gotoSubCategory")
        {
            if let destination = segue.destination as? SubCategoryCollectionViewController{
                let path = tableView.indexPathForSelectedRow
                let section = tableView.indexPathForSelectedRow?.section
                
                destination.selectedCategory = categoryTitle[section!][(path?.row)!]}
        
        }
        
        if (segue.identifier == "gotoDetailfromToday"){
            if let todayProductImageCell = sender as? TodayProductCollectionCell, let detailProductView = segue.destination as? ProductDetailViewController{
                let product = todayProductImageCell.item
                detailProductView.item = product

                
                
            }
        }

    }
}