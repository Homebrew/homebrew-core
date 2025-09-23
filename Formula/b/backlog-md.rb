class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.13.4.tgz"
  sha256 "3a5767c141cf7062980cf775fa305b2e909474f79c1189ef2123d75f993c34c0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2add355c5bebe5b1ff5d4316fdefaf394a7d5e79cc21a13c9f71b06cb8b5a3da"
    sha256                               arm64_sequoia: "2add355c5bebe5b1ff5d4316fdefaf394a7d5e79cc21a13c9f71b06cb8b5a3da"
    sha256                               arm64_sonoma:  "2add355c5bebe5b1ff5d4316fdefaf394a7d5e79cc21a13c9f71b06cb8b5a3da"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a59e03164f9ae3f2de6523bfed5356f358d45c98fe02249465d9cdbb85d53a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789d1d1f521450c8045ae322a1862d66757984e2718fdb02a6dc293cb30b9cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c223bb411c5d78f68d9910f2b19497900f1716620651bb612209db6ff18587"
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
