class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.9.0.tgz"
  sha256 "a070c2180f4a9f43794e0073cb9921c0a2a34479d1fec9a294233679c794cf9e"
  license "MIT"

  bottle do
    manifest_sha256 "ad8568b1f5b9262f4bfd65c400956a15f6001377949b9caba5c5d3680eae65e8"
    sha256 cellar: :any_skip_relocation, all: "c7d81f5d435c8dd9e9d49c6f76907cdc71522b398aa35c72d095df4ee2e2f5d9"
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
