class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.12.1.tgz"
  sha256 "6e80da3c240aeba2d2b29b66222bb5df967609fe280c908128810f2a9e99e11c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ac9c71017ef6ae947412dc68dcde99bff8f0fa16748441705d86e8f21c977f2b"
    sha256                               arm64_sequoia: "ac9c71017ef6ae947412dc68dcde99bff8f0fa16748441705d86e8f21c977f2b"
    sha256                               arm64_sonoma:  "ac9c71017ef6ae947412dc68dcde99bff8f0fa16748441705d86e8f21c977f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "add40aa7ae442edc8164db448555fc2c9e76f93684bf6468e6c3e85e10838c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b699d76d0a514a7c7dc3eb1c00e591f510bf95438c148d3a0da4850f9fa5ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283a8f68407323d5a9ca427a52f83c50de6fb18d515507d98254cbdb3c4472e2"
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
