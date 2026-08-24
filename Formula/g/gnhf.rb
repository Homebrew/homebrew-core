class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.45.tgz"
  sha256 "7ab3a8392a313728dadc3ee580f27748816d7dc0b090c95d3d3674c1b8f91395"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2d99124f389ecb2fb9dd36c23afe4dd71b90028aa415e5122656c32143aea08"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")

    output = shell_output("#{bin}/gnhf --current-branch 2>&1", 1)
    assert_match "gnhf: This command must be run inside a Git repository", output
  end
end
