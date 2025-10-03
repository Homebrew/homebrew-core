class McpGet < Formula
  desc "CLI for discovering, installing, and managing MCP servers"
  homepage "https://github.com/michaellatman/mcp-get"
  url "https://registry.npmjs.org/@michaellatman/mcp-get/-/mcp-get-1.0.115.tgz"
  sha256 "15b58431832df7c8038faa22dd09110f0daa5da6be7b208afd1455eace428cf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40ebc222469a196d53cfbed45e0a14156358e76ea72ac9bc43ba85e49a2bfc3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No MCP servers are currently installed", shell_output("#{bin}/mcp-get installed")
  end
end
