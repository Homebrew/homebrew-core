class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.3.tar.gz"
  sha256 "1799a64595cb820f62be8a62f0a2969c589eea4175b7b25d0b8712ec836c5632"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab0f77eb1c036df0c798fe404fcfbbf4919b043a29e803a51fa7de93aeefaee8"
    sha256 cellar: :any_skip_relocation, big_sur:       "11426ff36ab774794e844b72f85ee13da426cf300655b38b0b67cce572ea7bb5"
    sha256 cellar: :any_skip_relocation, catalina:      "f96e86c63f91472cf89dc1ed3958de237d40e052a0dee38720f86daf42fef430"
    sha256 cellar: :any_skip_relocation, mojave:        "6e1905f5bf03d51f68b548555534ec4c066020c0e15a70d4c20e28fe2005734c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "605ec0cf0919d1b84402d4a082477212c9e8de4d22ec1b82844795ee327452b0"
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
