class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.3.tar.gz"
  sha256 "b44eeb77d35bd342c28aeed8c0f40a8898694010e080b92ad13e5d072014a642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b73b9515e40315ffdf4551e1f3326b7bbfd9197ccd27e0ea7c0dda2e1bef4ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "23b8332b7f389a3fc1b3997afb18788d3e05ca0f444f212eab2b24a32ffeaec5"
    sha256 cellar: :any_skip_relocation, catalina:      "e199f0488bb268165c6d3d0cf6e163e19df69c7e8c8ef1e0c2d991c136c1c339"
    sha256 cellar: :any_skip_relocation, mojave:        "e70eebe8f3ec2231517eb95d7b25c5aa4198247b6351c79adad87b58f4c03ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a1d7fb499e5b196d2252d24062594bc60f0ceeb00434630fbcc1cb58440709d"
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
