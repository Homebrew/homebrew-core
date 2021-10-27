class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.7.2.tar.gz"
  sha256 "aa61149a91a20a6ced531bda02b63491fd8f7cf7d23a373090ce1d605475b533"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fea9d44c79aa9471a9bf1c1f42f544cf06eeebe9fe0bba77962776d9327a3c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32fbfa81dff42b0f2c830cb06276c4c209a8eb5d0f94576faf17d1112701c839"
    sha256 cellar: :any_skip_relocation, monterey:       "0eaa520e15e95091c3dc0c9cf121bba437fc5ebdfc4456d8c8b9c00e808cbe56"
    sha256 cellar: :any_skip_relocation, big_sur:        "d84c330c8713efadb2482ec2711163776232fae7eb64533af4bbcb648a227d1c"
    sha256 cellar: :any_skip_relocation, catalina:       "eb84a1f53766e2f94a6fc55561ba4386879439cba0009921bbaf03c660106b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c574b960b46a968f438d34450c0cb1c3c3d71dd1961cdd5896d5ac80a548477"
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
