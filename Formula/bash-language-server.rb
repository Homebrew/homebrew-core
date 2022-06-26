require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.0.4.tgz"
  sha256 "88a676b6ad4dc6409a813588fd975a97f881b8f4c2bb4fcb3d4880302606dc2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4eab9f073fee502d3fb8ff095604b6bd1c9f2b33f6a84d7020ef0fc1beb5f1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4eab9f073fee502d3fb8ff095604b6bd1c9f2b33f6a84d7020ef0fc1beb5f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "58e20942d6fcd90bf7d78deba2b7c4d6f3473a2f8074318082eb76253cf369c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e20942d6fcd90bf7d78deba2b7c4d6f3473a2f8074318082eb76253cf369c5"
    sha256 cellar: :any_skip_relocation, catalina:       "58e20942d6fcd90bf7d78deba2b7c4d6f3473a2f8074318082eb76253cf369c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eab9f073fee502d3fb8ff095604b6bd1c9f2b33f6a84d7020ef0fc1beb5f1a"
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
