require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.2.1.tgz"
  sha256 "6fba9c2889a0ca2f5c4245c06ff9a68d0c04550055d181edc1c1d636d4a01466"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0426d9152f20a41e56ddbc64446b5a56c727577c2a2595ab9a06b7c8be3bf5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0426d9152f20a41e56ddbc64446b5a56c727577c2a2595ab9a06b7c8be3bf5ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0426d9152f20a41e56ddbc64446b5a56c727577c2a2595ab9a06b7c8be3bf5ff"
    sha256 cellar: :any_skip_relocation, monterey:       "2fd78c337d3f221fc19880e489e9758a414e8e782792215a153f671986c2aa55"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fd78c337d3f221fc19880e489e9758a414e8e782792215a153f671986c2aa55"
    sha256 cellar: :any_skip_relocation, catalina:       "2fd78c337d3f221fc19880e489e9758a414e8e782792215a153f671986c2aa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0426d9152f20a41e56ddbc64446b5a56c727577c2a2595ab9a06b7c8be3bf5ff"
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
