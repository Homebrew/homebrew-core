class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.7.3.tar.gz"
  sha256 "f6b178e2536e3fb141db8c532b831e555253485fed4e0ad1a139c0998d5d7f3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec89b8ad16f0503a052551872008fbe442b895527f424abc13c9f824bb34cd86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87c41d3879feeb69b671668a00029a2999bcef5e2881de5b7ccd82075472a8b1"
    sha256 cellar: :any_skip_relocation, monterey:       "95cbd187506cc9b582ef1e222b547a24f0669edf73141941b91ce3b09a9d90a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "79310006f7eb09a4c76ee567f43d249627362e2967f265385f224eea7a7a81b6"
    sha256 cellar: :any_skip_relocation, catalina:       "4f4db269d4f82d4978e21273f6f00c6b909988c05b822993daf44e59f33a0852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb54c89689c5ba88e1b8283c42d98690ff61e5b5947bba54262330e829375a16"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "zsh")
    (zsh_completion/"_limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "fish")
    (fish_completion/"limactl.fish").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
