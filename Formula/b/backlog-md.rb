class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.0.tgz"
  sha256 "d314e2391b4034bcfaab3fcd5247262fdb21eb2ee0b868039ba9a1791350dd19"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "525f99a30e69cc897aff52c6c2c9349ea034f5158bf5d898d7d1a0267d2d6f8a"
    sha256                               arm64_sequoia: "525f99a30e69cc897aff52c6c2c9349ea034f5158bf5d898d7d1a0267d2d6f8a"
    sha256                               arm64_sonoma:  "525f99a30e69cc897aff52c6c2c9349ea034f5158bf5d898d7d1a0267d2d6f8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "826710807478ddc03839c5d0b4688eeefa89721b1d01c788e591087228727e77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26d35d65b2f8714cd7406e52e015e07f57c270f468314f7878ac41adbca7510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89cd7a58095c5518a54acfbb48f5d55c0f9c4ed5d95dc1e5c2ee6ab3ab0e2b27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
