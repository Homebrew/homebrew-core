class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-5.4.2.tgz"
  sha256 "864f609c18c8d2657b69f94d050bed977ac3fb8371c9dca784c2eeaeaad1d57b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9062a6bfcfd895728ee8166b0b20002df24c5e3e65ebb40121d37f82d6e9cc7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
