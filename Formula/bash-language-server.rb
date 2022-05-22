require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.0.3.tgz"
  sha256 "4d6a867f5c4c10fea46c563128eb9d0f0cba4bdd0e004ee6fd1b0101861f5ab2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d942af49ea0b5cb649fea031f9068bce2d05e29ed27f2a6ba7c8df90a6b1f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66d942af49ea0b5cb649fea031f9068bce2d05e29ed27f2a6ba7c8df90a6b1f3"
    sha256 cellar: :any_skip_relocation, monterey:       "c503581875b31ce39a99f023ab56ee8cce3cb15e4c9b198d7e51845de8adf689"
    sha256 cellar: :any_skip_relocation, big_sur:        "c503581875b31ce39a99f023ab56ee8cce3cb15e4c9b198d7e51845de8adf689"
    sha256 cellar: :any_skip_relocation, catalina:       "c503581875b31ce39a99f023ab56ee8cce3cb15e4c9b198d7e51845de8adf689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d942af49ea0b5cb649fea031f9068bce2d05e29ed27f2a6ba7c8df90a6b1f3"
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
