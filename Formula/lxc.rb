class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.12.tar.gz"
  sha256 "6061ff3346b0e7ab2736ddecf1dadc2581d93d89155bdf77622945db6f27321c"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f64b62e051bd420b6a8f97f129b33dae8284582d19c6b1a3a0ad35bd4b809c8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f64b62e051bd420b6a8f97f129b33dae8284582d19c6b1a3a0ad35bd4b809c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f64b62e051bd420b6a8f97f129b33dae8284582d19c6b1a3a0ad35bd4b809c8d"
    sha256 cellar: :any_skip_relocation, ventura:        "6b2e473c3cf0af684ff9ad0b57a2088a0b195dc4e7ecf86b0b0f365b7ef1d575"
    sha256 cellar: :any_skip_relocation, monterey:       "6b2e473c3cf0af684ff9ad0b57a2088a0b195dc4e7ecf86b0b0f365b7ef1d575"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b2e473c3cf0af684ff9ad0b57a2088a0b195dc4e7ecf86b0b0f365b7ef1d575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2eafeded6e4c313ec057d0e538cc0a0dd4badc3d25b6501427a6884fd3b32ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
