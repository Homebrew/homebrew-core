require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.1.0.tgz"
  sha256 "36646b3788e238b6e4d2d5c6b8adef86ee30d4fb1cd8d6cb7f68e674dc5f216d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e5313f877b77afad07f9418b5a4bc0828e911173d6bd4b0726dc02885fed4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9e5313f877b77afad07f9418b5a4bc0828e911173d6bd4b0726dc02885fed4a"
    sha256 cellar: :any_skip_relocation, monterey:       "ea2aa92dcfe287797e4eb693dfbfaede9ab13c28b177fa4c7f500b92d8e261f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea2aa92dcfe287797e4eb693dfbfaede9ab13c28b177fa4c7f500b92d8e261f6"
    sha256 cellar: :any_skip_relocation, catalina:       "ea2aa92dcfe287797e4eb693dfbfaede9ab13c28b177fa4c7f500b92d8e261f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e5313f877b77afad07f9418b5a4bc0828e911173d6bd4b0726dc02885fed4a"
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
