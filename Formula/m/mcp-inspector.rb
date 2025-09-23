class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.7.tgz"
  sha256 "5f849b4d39120202934662efe7bbfac3de2a4524ef5445eed04693da3a7aea37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47011804c21d9efbba4f62dadad7f9ea268756d9e1b65d1426a6d92cdeacd779"
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
