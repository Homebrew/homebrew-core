require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.0.0.tgz"
  sha256 "23a2a0f8b62a2192f001ab0811051b085c11de6203b8358417ade21c0083be7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195d388a08691cd1afc863809b469bf77a086f3bcbc755edaa992e17876fd882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "195d388a08691cd1afc863809b469bf77a086f3bcbc755edaa992e17876fd882"
    sha256 cellar: :any_skip_relocation, monterey:       "2cadb290740105a86dabb3f2b0762c0b77aff78a1c747bb4bb511ca8fb8c9c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cadb290740105a86dabb3f2b0762c0b77aff78a1c747bb4bb511ca8fb8c9c97"
    sha256 cellar: :any_skip_relocation, catalina:       "2cadb290740105a86dabb3f2b0762c0b77aff78a1c747bb4bb511ca8fb8c9c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195d388a08691cd1afc863809b469bf77a086f3bcbc755edaa992e17876fd882"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
