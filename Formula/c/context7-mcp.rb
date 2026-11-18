class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.7.3.tgz"
  sha256 "ffa998e5c835fc5eff2ae59770531340e4d7ed42be00740c52893097425548af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68156948c9071543b25674cf050fc18d12c6d26f438be09d122e4217dcedc98e"
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
