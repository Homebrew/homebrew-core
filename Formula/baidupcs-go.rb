class BaidupcsGo < Formula
  desc "The terminal utility for Baidu Network Disk"
  homepage "https://github.com/iikira/BaiduPCS-Go"
  url "https://github.com/iikira/BaiduPCS-Go/archive/v3.6.1.tar.gz"
  sha256 "07e1d802e6b49425a53b883c354d8b753de55f7005ac8c7b27cd8396db0447da"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c1610dfb0beb9a3ee4ba68209fef1440dd6a7cac848e5cde41d2cb3379335a" => :catalina
    sha256 "3b5d79236674f7c222bda94ef560e74414dea2fb219c2e6acc63c66b662c722a" => :mojave
    sha256 "4965b6a261743ad46b7625803f0f0efba3a80d4af8dd81a66b77dc7c148951f1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"baidupcs-go"
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
