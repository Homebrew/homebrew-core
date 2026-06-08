class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.22.0.tgz"
  sha256 "32fa820fde3c75357a206bb8409adaa5d9b110efb2cfec2cd4f9c7af1f1d53ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e611d3212a6e67d8219d63727473f35af1f1630aa28c2254b07712794f60ccbf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    # Remove incompatible and unneeded prebuilt binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    rm_r(node_modules.glob("@rollup/rollup-*"))
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
