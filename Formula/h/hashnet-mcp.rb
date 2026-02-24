class HashnetMcp < Formula
  desc "Hashgraph Online MCP server for agent discovery and chat"
  homepage "https://github.com/hashgraph-online/hashnet-mcp-js"
  url "https://registry.npmjs.org/@hol-org/hashnet-mcp/-/hashnet-mcp-1.0.24.tgz"
  sha256 "1a10936dbbd9e715f0b5b3596b17a00d8cf74924cde5965f792b390c91aad9a1"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/hashnet-mcp up --help")
    assert_match "Usage: npx @hol-org/hashnet-mcp up [options]", output
  end
end
