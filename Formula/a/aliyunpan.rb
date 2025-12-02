class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "65003e0925e5f64b20f47ea030aa01cb40972dc4cce67cc93a69282d88f254b0"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faad7d7d6aceedefc2080e2efc7db379f6e0d6640d0f1acbd2734ee9e53f6422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f43f03044ff8db6b97fee26628dbe66343935e13e53aee6d973adfddf0924b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43f03044ff8db6b97fee26628dbe66343935e13e53aee6d973adfddf0924b97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f43f03044ff8db6b97fee26628dbe66343935e13e53aee6d973adfddf0924b97"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a3e1de0f284f8c1bd1c0f8a96db80f885464e3f5e5a47c750bf3a0ff921fe5"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a3e1de0f284f8c1bd1c0f8a96db80f885464e3f5e5a47c750bf3a0ff921fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fe036fc957c7ec78225a43510603dde7b1fd2cf69836a692a388cfb1690e85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7f77f47dc25c016a62ac1ce13546514e281d0f57bef014a32215a4b68bc0dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
