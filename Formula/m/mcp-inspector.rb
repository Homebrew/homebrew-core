class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.18.0.tgz"
  sha256 "8a287a136d1c3ca8c2a685a8aa5da83d5f2e739bc31ade48e2d2a0a3a92292a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b78973b9f3d9c1c8168726f92a56a448918040d9f94b97fa252a209066944596"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
