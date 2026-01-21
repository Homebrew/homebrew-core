class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.0.0.tgz"
  sha256 "dcd2ac43fbb74e9638e4ba669e4f2463876f2ee1e55c709143df3713f376f763"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "afa19d72cb71ca74c9edacc8e6ca720c7d041b7db37ed2d2ca397841a55367b3"
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
