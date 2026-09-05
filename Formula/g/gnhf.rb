class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.48.tgz"
  sha256 "4c94c9c0318729ce3682ffd8ee49183a5ec37de69c370bd2abae26447091efb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "082c4d78b3c6e5881e3a333e40dd04b5e3d0a3de169739cfe38d6fee47e91426"
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
