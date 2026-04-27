class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.2.0.tgz"
  sha256 "95b7914e50fcb4cb7d73d7ec279205b5a184985ffdb47cf3af5053e98e60abd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1259097fdbb08d0c3f44bc85e4393fcada8a36eb2a38cdf8c303800f02962336"
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
