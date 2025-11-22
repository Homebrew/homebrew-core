class AirtableMcpServer < Formula
  desc "MCP Server for Airtable"
  homepage "https://github.com/domdomegg/airtable-mcp-server"
  url "https://registry.npmjs.org/airtable-mcp-server/-/airtable-mcp-server-1.9.5.tgz"
  sha256 "89821f51124b42c8c1d2bafaf277e80319e08ea84294b8073413540c3ff19f36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cb13f68c72ae2059a2fffe8423988553ead8577c5c5b59a08cc392cf5c8333b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["AIRTABLE_API_KEY"] = "pat123.abc123"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/airtable-mcp-server 2>&1", json, 0)
    assert_match "The name or ID of a view in the table", output
  end
end
