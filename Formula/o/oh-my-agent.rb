class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.26.0.tgz"
  sha256 "fb56c076c70479503f2dd11f2f043e87405123a0ca0108b78433a3df0e4f79ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba98fd41a85808d02ca21affa27eecb41e9b3960c240ec464dd2f617e44e3efc"
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
