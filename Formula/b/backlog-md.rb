class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.48.0.tgz"
  sha256 "48ffb8cc6b3a9bb9acd2fe162a5496115bf50742d687f5747df41e448f769ad1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "65fb41a9bd2f8bda4f1b08582c65a4a93ffa1354290c0bffef0b24f92afc4fe8"
    sha256                               arm64_sequoia: "65fb41a9bd2f8bda4f1b08582c65a4a93ffa1354290c0bffef0b24f92afc4fe8"
    sha256                               arm64_sonoma:  "65fb41a9bd2f8bda4f1b08582c65a4a93ffa1354290c0bffef0b24f92afc4fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecced0144b5e2acf09af2613dc3b09a795abf9aff815dda9b59e2972f8e1e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddcc79c247cc1b01c503544dd928ffae0b28e912710220ee70b96329bd0aca14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141d406575c94fe4b067e0d8e4af58de8532821811e8c506a5c83c5f808f88e0"
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
