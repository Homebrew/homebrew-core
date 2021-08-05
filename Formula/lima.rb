class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.0.tar.gz"
  sha256 "65790d01960f64eb3168f0361649c7e21478991d590922e2065998e01802cf71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7a4b15e915e00c3727b92e120094d65cae944fe4df3bb8662ad2632c51bc5c9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9045fddf6a0d61c061136284e656e2e6ce36c5a659e73917448412b9a540813"
    sha256 cellar: :any_skip_relocation, catalina:      "500df539541fc9870bad905df46619f129c146d43ac50e3b15dcbfa205caf3b4"
    sha256 cellar: :any_skip_relocation, mojave:        "310bf7d4c23bc70c2d83ad319a2eba9d11cf43f4e9adfab3fbc09dd679d55377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061affb4464aae135909a465c1248876bb59eb90b89c21811a5bfefd440c991c"
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
