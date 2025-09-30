class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.8.tgz"
  sha256 "18e8cdc33bfb348266c031d235d7dc489cfccb7b873d4e22a9fac616fd812f0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19421e032cab582bf805ce3cbb2be7ebb9733cf204a06e4e1ce0a537baa2fd9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
