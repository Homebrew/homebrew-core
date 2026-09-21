class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.1.1.tgz"
  sha256 "cbd5f81ca37b42ad5491099017b00d12107eb075bb3111c7a216b632fac97c4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc59d626fe7a6acf766556251a39a4276cd6bac5933df4746f07f7abda0b95f3"
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
