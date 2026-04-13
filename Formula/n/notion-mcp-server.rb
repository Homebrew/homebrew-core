class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.2.1.tgz"
  sha256 "b856cea9d403166f4a46049b0e011865bd90272fd9bee14e22cf1cc6f06c0b70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a5dd2857c2d79a0d096f1ec95fcb1494c3dd728200c20d250c9525f614a3252"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion data source", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end
