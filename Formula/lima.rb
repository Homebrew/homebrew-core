class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.0.tar.gz"
  sha256 "65790d01960f64eb3168f0361649c7e21478991d590922e2065998e01802cf71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbfef48a28e84e5df50f73036283ecd88784149915c1803b6c03b68ef20d4bc0"
    sha256 cellar: :any_skip_relocation, big_sur:       "162dcf341599f5db224b3c70ac46d93edfd44434b97caac3790284b356cc4f38"
    sha256 cellar: :any_skip_relocation, catalina:      "7ddc0fa28464926a089228d31d88cf0ec6b6e2f3aa82ac229ac242bde670d626"
    sha256 cellar: :any_skip_relocation, mojave:        "876373ce97e24e2d19b79797bd8185131e31cefc59eefe55f81e86077ddc0b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de719ffe3beacd58fcc202f7c68e1676dda5678ce2ca457eae4869f836221ad9"
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
