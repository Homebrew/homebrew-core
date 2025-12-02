class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.31.tgz"
  sha256 "196dae5a48887c48f356e6836198784a89fc06a5f21cbb50808cea0487a4d017"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "743693a10dee89298f8f83c90de50bb8713e76d9595bdb91e2f8762a0642aeba"
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
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
    assert_match "get-library-docs", output
  end
end
