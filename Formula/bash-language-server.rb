require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.3.1.tgz"
  sha256 "af2132dafd161dbe3c34ce89eabb6860954bfd4643bd60409c9853e2d21e9148"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b46696c454753984ed3d7128e7928f9870d4769a35a98422fb8eed383683ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b46696c454753984ed3d7128e7928f9870d4769a35a98422fb8eed383683ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b46696c454753984ed3d7128e7928f9870d4769a35a98422fb8eed383683ee6"
    sha256 cellar: :any_skip_relocation, ventura:        "0931177d299103d3e317bcee5580a2b918a6c0b1c8aa64435f7ecb1609d730b7"
    sha256 cellar: :any_skip_relocation, monterey:       "0931177d299103d3e317bcee5580a2b918a6c0b1c8aa64435f7ecb1609d730b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0931177d299103d3e317bcee5580a2b918a6c0b1c8aa64435f7ecb1609d730b7"
    sha256 cellar: :any_skip_relocation, catalina:       "0931177d299103d3e317bcee5580a2b918a6c0b1c8aa64435f7ecb1609d730b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b46696c454753984ed3d7128e7928f9870d4769a35a98422fb8eed383683ee6"
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
