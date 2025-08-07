#!/bin/bash



# 退出时只要有一个错误

set -e



echo "📦 查找并转换所有 Git 子模块为普通文件夹..."



# 检查 .gitmodules 是否存在

if [ ! -f .gitmodules ]; then

    echo "✅ 没有发现子模块 (.gitmodules)，无需操作。"

    exit 0

fi



# 读取 .gitmodules 中所有子模块路径

SUBMODULES=$(grep path .gitmodules | awk '{ print $3 }')



# 遍历每个子模块进行处理

for module in $SUBMODULES; do

    echo "👉 正在处理子模块: $module"



    # 删除子模块追踪

    git rm --cached "$module"

    

    # 删除 .git/modules 下的子模块信息（如果存在）

    if [ -d ".git/modules/$module" ]; then

        rm -rf ".git/modules/$module"

    fi



    # 添加子模块目录为普通文件夹

    git add "$module"

done



# 删除 .gitmodules 文件

echo "🗑️ 删除 .gitmodules 文件"

rm -f .gitmodules

git add .gitmodules || true  # 可能已经自动 staged



# 提交更改

echo "✅ 提交变更"

git commit -m "Convert all submodules to normal folders"



echo "🚀 子模块全部转换完成！你可以执行 git push 上传更改。"


