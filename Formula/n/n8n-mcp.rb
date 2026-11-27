class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.104.0.tgz"
  sha256 "9d1362871ffd9cee8a154d0077c2131025c502710e8eacce7f86542d4859d26e"
  license "MIT"

  bottle do
    manifest_sha256 "49d2dfd88e045c59430af1dd136df1f0e7e4214d76288f2801a597dcfcceb563"
    sha256 cellar: :any_skip_relocation, all: "f5e943f3346ba35199be54d04555081bb94f4699ec4ec413763365f27a571153"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = [
      %Q({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}),
      '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
      '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}',
    ].join("\n") + "\n"

    output = pipe_output(bin/"n8n-mcp", json, 0)
    assert_match "\"name\":\"n8n-documentation-mcp\"", output
    assert_match "\"name\":\"search_nodes\"", output
  end
end
