require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.1.0.tgz"
  sha256 "36646b3788e238b6e4d2d5c6b8adef86ee30d4fb1cd8d6cb7f68e674dc5f216d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ba17d5cf63c0244861f8dec67ba9f122b0d1bdf0e841850448cb1d04c42da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92ba17d5cf63c0244861f8dec67ba9f122b0d1bdf0e841850448cb1d04c42da6"
    sha256 cellar: :any_skip_relocation, monterey:       "c65e3487c21c20e6e8ad1ad4b4292fecae275a6452c9b7b9e47ad7e2943b0f1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c65e3487c21c20e6e8ad1ad4b4292fecae275a6452c9b7b9e47ad7e2943b0f1e"
    sha256 cellar: :any_skip_relocation, catalina:       "c65e3487c21c20e6e8ad1ad4b4292fecae275a6452c9b7b9e47ad7e2943b0f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ba17d5cf63c0244861f8dec67ba9f122b0d1bdf0e841850448cb1d04c42da6"
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
