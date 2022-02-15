class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.6.tar.gz"
  sha256 "9e263f8ba81870536e9c7453ab06ef9524696a0ddbcf5ea3f56132cd448c7e27"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d6ed1661f5bcc77dd2c6a9a230eaf3024c34543eec132b7f3e268d6f032ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a92c96e64d4e967fd6355ccb4f02980e8311d7431861c7c00134be72765e56b8"
    sha256 cellar: :any_skip_relocation, monterey:       "5002411de5624d982114461a20812f7b8e3bb731fd055ac300fcf6d9069887c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "576cbdbadb43f6abb0ede6f8e738858bf72a5a483d6d1afc1425e3465bef8a7b"
    sha256 cellar: :any_skip_relocation, catalina:       "d37c17419f4987928c5be59dddbf66d4130adb20de6a7fab729679569696c995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd19473b665ad7777bc07394675b8b054d15d9d465589a7623c87001210a427f"
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
