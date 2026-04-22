class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.1.8.tgz"
  sha256 "48e9a3e2728d7f2e958d55b0e21ccfcbf4c12c3746e3bd77e8abff906e11e370"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4205353adbea9508898a1e070aa759a7af5b3f6f020ae0777190ff4a748872c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
