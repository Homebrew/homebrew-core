require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-4.8.1.tgz"
  sha256 "a1bfb7ac63a9443c87899e20fe70c149f1785549169c87670250c5d9822d05b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a3069e89f26b7d8fb10f22c7fe19138150b01bff6399f68cb883d364e19dd7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78bc8e91a84d56c02e2fc256479d4ce647da9f8930bc96c4e9b89be8a110edc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5a78edcb6eaa651c10fe4efa02d7c82044f8cf2132c2d6e688724adeb9989be"
    sha256 cellar: :any_skip_relocation, ventura:        "cd58172cddeccf42b02aa869cb70f1fc263f431e422ec17297cfa925dd9516be"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1a03030393e3335269274aed9192f54435780c95e8f4330018237abe662f39"
    sha256 cellar: :any_skip_relocation, big_sur:        "07fa897c8953bfbcd6d5ed1a21dce9158568f48aeb8a85fc35d850a00c9a520f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a1caf862763ded8dfdf36dd08aa9769cfa4af07cb244ad54621ef07f67f72b"
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
