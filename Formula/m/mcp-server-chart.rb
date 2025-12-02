class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.5.tgz"
  sha256 "9821e9f6b2c7bae65b475e5f5fe231edcf45d2b0d10c7578d5f11a1ea98a7299"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36b8da40ce3cadc617715af80522027742dc76c7edfe6e5887a7aa1221b93736"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mcp-server-chart 2>&1", json, 0)
    assert_match "Background color of the chart, such as, '#fff'", output
  end
end
