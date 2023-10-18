require "language/node"

class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https://github.com/nwolverson/purescript-language-server"
  url "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.17.2.tgz"
  sha256 "de88a221181a0626db87fdcd1b7efd3f7846aa3a53b38b3eb0fd3b0799469b18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1a31f54e9e9216f2732e1c1dbdfaedeada2d6079e893af9aea5fc46a938285f"
  end

  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

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

    Open3.popen3("#{bin}/purescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
