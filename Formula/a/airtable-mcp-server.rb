class AirtableMcpServer < Formula
  desc "MCP Server for Airtable"
  homepage "https://github.com/domdomegg/airtable-mcp-server"
  url "https://registry.npmjs.org/airtable-mcp-server/-/airtable-mcp-server-1.11.0.tgz"
  sha256 "41d2f18fecbd7eec8dcaf1b7649c5b6cf040c4065ba3014e809fc906ec08e9d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f9b74fe66748eb63f12a7292b4e1688f81f39bce015ad00dc81cae3fdcb776f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
