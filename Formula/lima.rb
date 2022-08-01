class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.11.3.tar.gz"
  sha256 "562166d1266013bd434444edb8c12b53a9fe7e4a36f5371ac9269d87b173adc1"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7dc8b57742eba8a88fa12162d5686ce0575114fbb2183c9d874019123dde00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88cf71134e0223169252b836df74962a34103e63559791bb231fb2255c0644cf"
    sha256 cellar: :any_skip_relocation, monterey:       "241003ff895f2ffa25320dc6a370d590edb5cf4cef3e2698b416179c87dc0553"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf1a86b4fe1b5d27b6368f00e8126775d072e8ca6f8e1f084989a15a5bf6b53"
    sha256 cellar: :any_skip_relocation, catalina:       "449fa6d775d4c32b339416d12d99d49e94e271a4c265cfb76adfca170d6ff2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9da2792ebe616f34eff15cf6569af469c40ec73be421e8eb90cacf109d24ab3"
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
