require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.0.2.tgz"
  sha256 "73f9b31f4ce53b97668c6057a4efbb38653c4e930d6407e08dbd6747cb7dcccb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d891bce3d24100092b10e87993e4696874cd756e14d0a9f35d48bc258a69ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d891bce3d24100092b10e87993e4696874cd756e14d0a9f35d48bc258a69ed"
    sha256 cellar: :any_skip_relocation, monterey:       "0edeaab537a6fcca09ee5d6a07763e0a888849a0220e4ac1f77175c826f04d3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0edeaab537a6fcca09ee5d6a07763e0a888849a0220e4ac1f77175c826f04d3a"
    sha256 cellar: :any_skip_relocation, catalina:       "0edeaab537a6fcca09ee5d6a07763e0a888849a0220e4ac1f77175c826f04d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d891bce3d24100092b10e87993e4696874cd756e14d0a9f35d48bc258a69ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["NODE_OPTIONS"] = "--no-experimental-fetch"

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
