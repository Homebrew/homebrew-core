class ClaudeCmd < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/kiliczsh/claude-cmd"
  url "https://registry.npmjs.org/claude-cmd/-/claude-cmd-1.1.1.tgz"
  sha256 "c6b990f7c55ec1281dca603b284d55b468ca7bbdfe217fc8091f5a8f85f16367"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ae7ff8473e44498a079bf31fc5072742d7104998ac1ecd499706159d4136fa6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/claude-cmd list")
    assert_match "No commands installed yet", output
  end
end
