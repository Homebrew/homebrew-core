class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.41.tgz"
  sha256 "2eba212fac15dd36e8147ce6cade319d6d32f0813e76f1aa745c77e4072e026f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e963f38d271671c95f680e3020821cbff6b9bbe51032c7d963bafe60f556d94"
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
