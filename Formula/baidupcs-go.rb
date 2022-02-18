class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.7.tar.gz"
  sha256 "e365fabee470ea5ab51b9ba034b5168dca1d0d537ab36274a17bfc460036b965"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7411bc1387d591824785767f0ce107ccf641d91da63d150aaadb96d2f93131a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10df0fbd14660127664114a0abb94531f117038f7fb72aede17f6912f931ef13"
    sha256 cellar: :any_skip_relocation, monterey:       "8aecb1583fd38cccd1a6c24d4cd57de861e417eebd2b7e61949662c4ea106ae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "40b192dec6172debd51fc5684051463516e7eaa1c8b162ad1adacfb69aced736"
    sha256 cellar: :any_skip_relocation, catalina:       "d062026fedbc89d9b2c06838a86146410183faf84608a7a504f270368b127422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "856d1fefecca36ac30cfd153001d7362453741cff09e048ea5a01936dbaafaad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
