class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-1.9.0.tgz"
  sha256 "a047243d0f6d68556feaa54cb709e65211a230bdbfcfeeab88be572e53833822"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea0e3e1c6ad1fc260d8508f4f2fa72a6a1e1b6b0d8c784d0ed45c4660a7960c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion database", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end
