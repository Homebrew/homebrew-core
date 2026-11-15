class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.6.1.tgz"
  sha256 "dda051e78271e754b6c6fe6907bfb71ee28b3cd81efe8d39fb39268c3b10aec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81a969709b5f17620c2c3a4da57880baa8ce68cbc45ca2042343e36addcf30ac"
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
