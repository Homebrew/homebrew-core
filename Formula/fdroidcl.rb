class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https://github.com/mvdan/fdroidcl"
  url "https://github.com/mvdan/fdroidcl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "532a8c4c93216cbf13378ff409c06a08d48e8baee6119a50ed43dc0ce9ec7879"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/fdroidcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef0dc3e663006c1b297afba9938a3a275a92fba9dbcb2941e28a0c3fcddd6aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6ff8a6974e3f1a1729fbfb499043047ec2b277acba25304e84551cf72fe4048"
    sha256 cellar: :any_skip_relocation, monterey:       "731c9962bc28fb2eef849886e576b951e0a02018607b4704ba6ac5dc9f935c99"
    sha256 cellar: :any_skip_relocation, big_sur:        "aed5098245121b6f7659bee09c2730e6349203f9816ede1e2288237b5307ae35"
    sha256 cellar: :any_skip_relocation, catalina:       "fa13c9f3630e79594a5cf71db75970dc193caa339576d7ca0ad1165d313ea192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b949401ff9f1beda983438e146f843539e3fd3dd7daf3f55c93c28976cb629c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "done", shell_output("#{bin}/fdroidcl update")
  end
end
