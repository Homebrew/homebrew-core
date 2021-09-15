class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.3.tar.gz"
  sha256 "b44eeb77d35bd342c28aeed8c0f40a8898694010e080b92ad13e5d072014a642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e3592deb763cb7c58e075f1d9bad60d8962ea271aa15f91a10bcd0f8a857127"
    sha256 cellar: :any_skip_relocation, big_sur:       "20cd239d420307cf736af58e2941ade9c6e9573a3d218464e663d65f86a16f4c"
    sha256 cellar: :any_skip_relocation, catalina:      "52cad85b1babda539a1818776b38d11b5784f8542071213d728f156d7c577e6d"
    sha256 cellar: :any_skip_relocation, mojave:        "8472f3c9e59f6730ad0a593cd213e57c313e2ecac1d850dda40c60a589e387b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609fa9e56629bdd55a2d958288ba8bde30cf5207e1236e61b0f15a5ad1b6e40e"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
