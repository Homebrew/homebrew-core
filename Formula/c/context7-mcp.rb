class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.9.1.tgz"
  sha256 "35b00e3a3b72628141f8e74325750063ce19b12339c2907a18ca77011c96ab61"
  license "MIT"

  bottle do
    manifest_sha256 "04383c983f67de6ed75ee1d10bf7b99513b9d60288b8abfa850d473d49019c85"
    sha256 cellar: :any_skip_relocation, all: "257f01f86f7801ec22b4a9f40f639368897785e68e640756dd28f080ed2c8b2c"
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
