class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.52.tgz"
  sha256 "05b61c0bba961084e29b664928817065ea1a89e9d4a772f7e3e3f9679a9290e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ef9883ac6027050fceab0e847089b14aff638c70e10e2b1d9fbfb81438b7ae2"
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
