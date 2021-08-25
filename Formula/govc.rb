class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.26.1.tar.gz"
  sha256 "de6ca53c7953fb30c3d966e83467491c39578fcd8d76ab523de966201cf674c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0312bb1bb091eb0069fee1edd31811ac6614ad7e57153ad8ecf4ecb433e2728"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c29c2dabdcb53538b977c4071d6d7c9a03025fc47a0e96745f465e2f92b27ff"
    sha256 cellar: :any_skip_relocation, catalina:      "1bcaae9bd0793b1264f65d5af2ddf1634ac31b2b9a20501d01f11738480db820"
    sha256 cellar: :any_skip_relocation, mojave:        "fd0e4f4e05bf16f9d1ff42428d7d20f3824901c46d41246165a71505c745ac92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31247b7c122ffa2644178c3d2b4e406e400f294a861d10d591443527c243299c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
