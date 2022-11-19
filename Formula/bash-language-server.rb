require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.1.1.tgz"
  sha256 "0251fef70b3367746ceb3576a5d9b883b094fe80f24af447e68fc24e33a63014"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28c83c200121ede2806a8230c81711664a20409a0d94d2db1de311f807601998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c83c200121ede2806a8230c81711664a20409a0d94d2db1de311f807601998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c83c200121ede2806a8230c81711664a20409a0d94d2db1de311f807601998"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c388dfc9d7f6d93acaa19f24b40dac7c2ad40c90367250742f95bb9c0bf5c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4c388dfc9d7f6d93acaa19f24b40dac7c2ad40c90367250742f95bb9c0bf5c3"
    sha256 cellar: :any_skip_relocation, catalina:       "e4c388dfc9d7f6d93acaa19f24b40dac7c2ad40c90367250742f95bb9c0bf5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c83c200121ede2806a8230c81711664a20409a0d94d2db1de311f807601998"
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
