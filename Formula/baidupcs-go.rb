class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.4.tar.gz"
  sha256 "11fa472cbfd1d63aee1d345784e1cb5503cf7b938d7f74f6b138c761c4f8eeca"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3b1d16f2258b7a996c662c74d6312627e4349e853c0fd3bf5f4665ae9a8f33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5975907ef5a45ce0ff3b3c7eea6cc5e1024b4938aab36123509ca4fb6e9e1928"
    sha256 cellar: :any_skip_relocation, monterey:       "2a3d4259df1e56f1b33d430781ef85598f5890dd29c9d7eb288b1791ebe57f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bef2623ea5296a38ad6063e35f732b21e14e65a163530da18763dec9a437469"
    sha256 cellar: :any_skip_relocation, catalina:       "a6a451cbf301960ddc61689355a4ed9d2bcb0889e2e25b0161b89358f6514000"
    sha256 cellar: :any_skip_relocation, mojave:         "b024815371b471e0fbce20f46cd4e2b3476873cf3e0b6563d630b9cacc51443f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92dbe6b2a76a70eea669805d35cb0a84f811c208e14950e07f034f11c4b46525"
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
