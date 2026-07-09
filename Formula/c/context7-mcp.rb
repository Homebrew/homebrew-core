class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-3.2.3.tgz"
  sha256 "008e8894a3c5468a546d5572ae9715641f0fca812df59523780da18990cf068b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5beffa6b12a0d80556d1ecb05b4403cea5b821381ab6b495ab4fe3e4c0ad32d8"
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
