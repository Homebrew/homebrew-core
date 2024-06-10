require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-5.4.0.tgz"
  sha256 "398971fee90b72014d72ca63b163e8f19d3c7db9528de8e43075c2ffa579b7b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, ventura:        "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, monterey:       "2367c9eb277dad9e05964c8e8a8039efab7c4e0e03f95e7ddfa3b8ced9b39f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e709a525dda8e236a868884bab24c15b6ea19ae4b1dad823578dc8ec785387eb"
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
