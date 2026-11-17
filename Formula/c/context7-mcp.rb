class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.7.1.tgz"
  sha256 "6a204d40ba0c666b2f40aee59d2a2c2bff57ae9b06a55a2a4f8dc3793c01ada4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ef74a8e998abc8e92874ace1ea406dee59d60c034fdeffaedbb73a091161087"
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
