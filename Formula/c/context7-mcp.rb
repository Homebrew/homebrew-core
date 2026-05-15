class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.2.5.tgz"
  sha256 "fb787f48021898f435e345cfaedf7e7c48dd81551505ef15e18d22e189c6b375"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c5ce1742ae14af3a7caff9dba7b9fbefb718dd35c36e1e966df43d3fb526d94"
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
