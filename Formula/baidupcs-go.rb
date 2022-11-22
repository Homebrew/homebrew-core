class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.8.tar.gz"
  sha256 "d6e4de5b68af92812593fbd964faa14a7c2ff16ffdd59356cefaf250fb0fce98"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e9e7b7b2025986de129bad668dc50da3877690853faf42ec0cbe41dfa4beefb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeaa557ffd5617b952c8bdc83796e16fdb4a4faf701e954a6ade7c86836a26c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffd8db41c5c4853aadd2a37ed95dd995ec98c62deae2702f1f0cf8e5917e2e30"
    sha256 cellar: :any_skip_relocation, ventura:        "66859e696eb07be86b06f1e5586558635b955961900f1a76f276cb73189c8b56"
    sha256 cellar: :any_skip_relocation, monterey:       "0f79668715b2aa2adb1ab57af38f20be4188f03df7dae2f81f3c6fda3c872832"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0ea61ebfe203fb578ea07891ec67d1063f7b9c9cb4a68145c5878ef5e43dd48"
    sha256 cellar: :any_skip_relocation, catalina:       "4382c40b5383d164299b6d5ead1c8db8bc9c760110231fb5ae2240e26c0e6883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb294d86b16bd37817a08d93182c022f991090a53f8cbb7fdf225c75391464e"
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
