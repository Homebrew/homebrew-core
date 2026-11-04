class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.5.0.tgz"
  sha256 "e685ffb5f3babe6e59c80e7472eb165b06ea2cd929114e4f9f2ef99dc41be59c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "920c4e4a5cf45abc8a3cdb62293ee276ab71873a4ac5e37d54df9f2369455d71"
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
