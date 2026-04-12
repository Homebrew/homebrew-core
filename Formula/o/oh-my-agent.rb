class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.28.0.tgz"
  sha256 "9d20deb80e879e956dd371d78259d28260cbbc3f8b047791befe61ec5b57c578"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ee9da68a3494c9e96406334ce8aaa3a6ff1f549ffa725ec49b7e5a850466a46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
