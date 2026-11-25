class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.8.0.tgz"
  sha256 "a9a5b28932c7dcdfb3944c1d12f74b100e2addea724e19ad611e2ec67e392db7"
  license "MIT"

  bottle do
    manifest_sha256 "7d43ec8455df8cf84578e9f56f9cc622464481bf15cbaa94641665f67ea31482"
    sha256 cellar: :any_skip_relocation, all: "f705c46008e77b205589aa0616f3b1277c51502bd38db3c579873fdc18969510"
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
