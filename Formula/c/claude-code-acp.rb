class ClaudeCodeAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-code-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-code-acp/-/claude-code-acp-0.13.1.tgz"
  sha256 "a8a6596cd3b15a367f81c95806c6626453ef07bd2eb89d692c919cad9ac1f021"
  license "Apache-2.0"

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_path = libexec/"lib/node_modules/@zed-industries/claude-code-acp" /
                   "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_path
    (bin/"claude-code-acp").write_env_script libexec/"bin/claude-code-acp",
                                              USE_BUILTIN_RIPGREP: "1"
  end

  test do
    assert_path_exists bin/"claude-code-acp"
    assert_predicate bin/"claude-code-acp", :executable?
    assert_match "USE_BUILTIN_RIPGREP", (bin/"claude-code-acp").read
  end
end
