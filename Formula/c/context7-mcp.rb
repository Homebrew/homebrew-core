class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.7.0.tgz"
  sha256 "35b5a51ab0db7ff66f3b391f2bd97cd38d60803dce584d38d97ea0b99fab7734"
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
