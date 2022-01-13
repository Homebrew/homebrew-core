class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.1.tar.gz"
  sha256 "b867cc9324b4b1029e466eb153040ef0cbef363a648a5c90f6a4f48efc0cc004"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544071d6e27bb5a4a28a07d7d0348e9f6c006a12a5d25dbbcee64c051042e931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9fec2c984c2fcaf8632685d191cdf9c206bc9255105c6819061a8d119c36dca"
    sha256 cellar: :any_skip_relocation, monterey:       "be9a2b2497a881c3d320451a369b7ea68a8b9ca4379267b3177fb08a1530b695"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c9dcb0961e9b9450e905b5bf09baeec30961f80d561b299eff1ba1e1e3411ba"
    sha256 cellar: :any_skip_relocation, catalina:       "693f148302ba78881887620146646914f270313504ac70048a1e01801f6797c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c337ac46d5a3bbc96315a4524c871ec21668b85dfef36f5a95ef33eb40dc925"
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
