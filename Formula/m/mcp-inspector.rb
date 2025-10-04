class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.17.0.tgz"
  sha256 "4c860c3348919cbbd32b32e7569b5140ffe5e7f021954012cf573de686f10767"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d48bcae60d3f1bf61229fe70cc9d94e1306005509eaa051382b4f25fe01667d7"
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
