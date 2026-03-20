class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.42.0.tgz"
  sha256 "69631938e3de7adaa48aa52ae0f6bc197b73abee4131ea7067b6d21f5d5b21a0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e0ee3301924300fa2b30ef54fd4bdd82f45abab3439c200fe09b30722f999635"
    sha256                               arm64_sequoia: "e0ee3301924300fa2b30ef54fd4bdd82f45abab3439c200fe09b30722f999635"
    sha256                               arm64_sonoma:  "e0ee3301924300fa2b30ef54fd4bdd82f45abab3439c200fe09b30722f999635"
    sha256 cellar: :any_skip_relocation, sonoma:        "11cdd9885fae921b24d8f65b17478d6c871a5e411b6676cc4b9ee2ba45ae48a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c4f0a12205fe0be197da574927825961d8d9e56b25ce5a46cc8663e3edc32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83827ba751c11b87954c3ecaa992981702f6965681447e575ae4841560ad6435"
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
