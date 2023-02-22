class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.9.0.tar.gz"
  sha256 "de71666e961a3eeb90f8aca7b11934c3f0296d1870e036a7c086ba1decfca8ab"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a493736ddb5671e2857addd80a0cb510a777d1cb14dcd50bc7beffca420e762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0a3bbc01ff311d813cbcd6a52869dfbba5209c6be099718fe91a9a206759f69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf64c9ad56ed8e980d08b9f2c180fb0f746365089efc68e8999a767667818ab"
    sha256 cellar: :any_skip_relocation, ventura:        "10d19f39051c8237bf2191efba15f6e207245f1f6983cc0060e09a4f93167b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "406b1f660ce69dc6ea9216ffd47bca8bf5522d31dad0da44edc0e2b22752e7f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de66cf50df5e988289591f0ccc31d49d99319fbb99e122760f6dd4f04c0db84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7cc7a5a6801b05ca2f3cc0f4b696196a260060bebe1374fa2efede1f15552b"
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
