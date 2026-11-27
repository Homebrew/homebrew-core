class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.53.tgz"
  sha256 "80a4d52c177c9512a797fb307d01b211dcb2510fb625557f386b07a3cd510e80"
  license "MIT"

  bottle do
    manifest_sha256 "d172a6728c646fea5f39fe3e01fab830a8fd2565c14e2502ba9c630a81e07f0e"
    sha256 cellar: :any_skip_relocation, all: "66f9ba8533b923611b231a8d2f9a400effa88a3390cad1ae010a561053a798de"
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
