class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.15.1.tgz"
  sha256 "ca2a78f91883b39425dc9f6d458f8f8dcb07aa31917f23884c7986dd9d563b0b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3629a336be097379373b682a093aa27d447254bce51a3679c824c1884aec6f1f"
    sha256                               arm64_sequoia: "3629a336be097379373b682a093aa27d447254bce51a3679c824c1884aec6f1f"
    sha256                               arm64_sonoma:  "3629a336be097379373b682a093aa27d447254bce51a3679c824c1884aec6f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "002333b746d9fa495bfc9f1f232a4ec6263a34d579295d441b4a960cf62cd557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a0d3b62df7549b50e3f052bd880045215e3fe4b418170ff820c0851971a9a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d314248edb76918b24263c49907ec18eb05aba6e854d95d911d1c0a90eeee49"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
