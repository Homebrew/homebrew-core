class Fy < Formula
  desc "A command-line tool for translation"
  homepage "https://github.com/jeffcail/command-fanyi" # 替换为你的项目主页
  url "https://github.com/jeffcail/command-fanyi/archive/refs/tags/v1.0.1.tar.gz", # 替换为你的 fanyi 程序的路径
  version "1.0.1" # 替换为你的版本号
  sha256 "b866bab017f59aafab82d8e0160474f471803ce80d8cdf94d071b3da26387047"

  def install
    bin.install "fy"
  end

  test do
    system "#{bin}/fy", "--version" # 这里可以替换为你希望测试的命令
  end
end
