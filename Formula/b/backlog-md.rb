class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.14.3.tgz"
  sha256 "5151f3f279ad5c62d9ac0ba585db14337de374586f93a64d19894ce62350f039"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4a92a37b8035ad4d6fd881ffcca2a3aad618c44c1c9b82f5f0ba92c0b6c62685"
    sha256                               arm64_sequoia: "4a92a37b8035ad4d6fd881ffcca2a3aad618c44c1c9b82f5f0ba92c0b6c62685"
    sha256                               arm64_sonoma:  "4a92a37b8035ad4d6fd881ffcca2a3aad618c44c1c9b82f5f0ba92c0b6c62685"
    sha256 cellar: :any_skip_relocation, sonoma:        "0062e61fd16a5d536825f1b37cfdf8f6107e53b7fb99719710045eb6eb459c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4784c658d87ab8469a0022f3e2fabbbcf21bda4155189358e16958ae3b1afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "337f6d99784c3a41fdea8159e7d27b873f1306b2c0e12126a17103ef377cdc59"
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
