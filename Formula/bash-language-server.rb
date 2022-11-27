require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.2.3.tgz"
  sha256 "9d52f149e372ce4a42a7b6b7b03fc3dc47ee23222004079f4a9b3046043f8174"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed55f1fd62aedf756a02c28c930c413f2c798b542a045197b506c34104a2847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed55f1fd62aedf756a02c28c930c413f2c798b542a045197b506c34104a2847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed55f1fd62aedf756a02c28c930c413f2c798b542a045197b506c34104a2847"
    sha256 cellar: :any_skip_relocation, ventura:        "c2fc7edaaa5269ebc074b3a76bd000dfc2f5121c5bf95554022aad4f65f4790e"
    sha256 cellar: :any_skip_relocation, monterey:       "c2fc7edaaa5269ebc074b3a76bd000dfc2f5121c5bf95554022aad4f65f4790e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2fc7edaaa5269ebc074b3a76bd000dfc2f5121c5bf95554022aad4f65f4790e"
    sha256 cellar: :any_skip_relocation, catalina:       "c2fc7edaaa5269ebc074b3a76bd000dfc2f5121c5bf95554022aad4f65f4790e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ed55f1fd62aedf756a02c28c930c413f2c798b542a045197b506c34104a2847"
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
