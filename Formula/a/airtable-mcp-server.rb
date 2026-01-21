class AirtableMcpServer < Formula
  desc "MCP Server for Airtable"
  homepage "https://github.com/domdomegg/airtable-mcp-server"
  url "https://registry.npmjs.org/airtable-mcp-server/-/airtable-mcp-server-1.10.0.tgz"
  sha256 "a0fe0f9d32e46d69af7aee638d8b2ff01bb1bf1b7fdc24745fcd85fb1a37bc83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8998f32c412424b05e7902b212eb12d4852ce36324fdd001fc78cc4e1e46a13a"
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
