require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-4.0.0.tgz"
  sha256 "4d404487c09852d696a3b0251e1f8d6f7d7ed0ec39e6feb74daec48f8a6f715d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9961b5a37ca9823789584484faa59325212d07421b2e77f18043c87ae6da044f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9961b5a37ca9823789584484faa59325212d07421b2e77f18043c87ae6da044f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9961b5a37ca9823789584484faa59325212d07421b2e77f18043c87ae6da044f"
    sha256 cellar: :any_skip_relocation, ventura:        "1cefcb238cce580e1254795890950be3a5d622093ee031e9e8f2d21e83b87cbc"
    sha256 cellar: :any_skip_relocation, monterey:       "1cefcb238cce580e1254795890950be3a5d622093ee031e9e8f2d21e83b87cbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cefcb238cce580e1254795890950be3a5d622093ee031e9e8f2d21e83b87cbc"
    sha256 cellar: :any_skip_relocation, catalina:       "1cefcb238cce580e1254795890950be3a5d622093ee031e9e8f2d21e83b87cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9961b5a37ca9823789584484faa59325212d07421b2e77f18043c87ae6da044f"
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
