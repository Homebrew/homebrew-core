class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.4.tgz"
  sha256 "0cac85bddf24f17caf12218fe593f43fc3025e4abb47997cc8fff518f1234085"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cf4924b20bb049ebb10ab93af5893ca449e13bc3e50b55dbace7c2248ea9b04"
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
