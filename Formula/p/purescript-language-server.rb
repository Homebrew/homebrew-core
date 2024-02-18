require "language/node"

class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https://github.com/nwolverson/purescript-language-server"
  url "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.18.0.tgz"
  sha256 "4814f287375c5b03ff71d11ab43e2eab7c87bb4d856d22db70cd45f9051ec327"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fa10a1604c4d0d482eb93545476554052611078e6fb118af709e6a66eb24a98"
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
