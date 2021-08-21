class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.2.tar.gz"
  sha256 "65d5482bc2a82cb244b978b8e1369bd5b1c429afce74651e5aea28e057a78ae3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a460bee52819fd273daa240a4e9f388961220721bf6a18fc36d8e465c5c93e36"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fc71def3bc7c2a8b94eb565e3f3ba6c92ba16677393b4fd2d960771bb1e5e8b"
    sha256 cellar: :any_skip_relocation, catalina:      "ec7b7010f8b8faf8aed8309e2b96e667cc3dbec4014d799a8dd4747ff7c73fa2"
    sha256 cellar: :any_skip_relocation, mojave:        "c48c4342d15b86b0fcdac3928ef8c2f55b8066e0413375c1ea8fc84914bab97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ef03e94941c849fb0e1930b05919c27864d145007d161262dab03bc15fe0be"
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
