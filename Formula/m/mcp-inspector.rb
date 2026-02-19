class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.19.0.tgz"
  sha256 "96dc25a9b4704e6ed86492306ece98f68ed80024c6fc2fcbc4e8e091187e43bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d24f8c0c6ad6e39f748a2117fccaebb91825f2b2973304ba395dd350626bee0"
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
