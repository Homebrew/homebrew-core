class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.7.tar.gz"
  sha256 "e365fabee470ea5ab51b9ba034b5168dca1d0d537ab36274a17bfc460036b965"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "111eefb9c7f8ae719169eac7077e8bddf33b2cdd00bad03feef94d40eab5742e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80eaa1ecbad6e50225610d22350ae9cb678343b2eb087672af9250497fc903b9"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a4ad281be6a60c5e5fe09af3c5720aa1f6dbae5715c43c803f035a7571ee30"
    sha256 cellar: :any_skip_relocation, big_sur:        "76a4a15ce1ead939d054a42600fde14db16174dd75c6206718af10c8fb98e927"
    sha256 cellar: :any_skip_relocation, catalina:       "2b330c09d1b39ead114981227255ff65090e316cadff7454272ac16893b12818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0aea12e4a2d233097b5a9e1d1f5eb98950699ba8ac2746f08c927a92aec8cab"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
