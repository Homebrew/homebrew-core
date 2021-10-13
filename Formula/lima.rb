class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.7.1.tar.gz"
  sha256 "635d03bde3a8e592350394d45f06b9bdea1dffe747b5a9739711d6e937f2faab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6a9ac0b4a82fd921bff51d6f0bf3390cfd3457a7e1857c7e861be03d605dc45"
    sha256 cellar: :any_skip_relocation, big_sur:       "3de7bb2f85dbbafbb5f6a5536eae0a6133b053b1d1a659288e0ea6b1a82d47e7"
    sha256 cellar: :any_skip_relocation, catalina:      "0effdc9c0bec1208470cbae19e18e8919ac4d06863e598bb115322f89f4fc45f"
    sha256 cellar: :any_skip_relocation, mojave:        "975078dce859460107fb12c110ad8100cf9b29578f41189ceff07bc252f795c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f6361a062b510df3099bdaee473772112475ba2edcf29c6670afa31bb24dfa"
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
