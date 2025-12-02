class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https://github.com/nwolverson/purescript-language-server"
  url "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.18.5.tgz"
  sha256 "2b4a55ab4ee71dda3f9feb290437dcf2b8b083344cab8490089d6caab123341d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc5f49524090444f724689302457dff282c2ee7655893e172c47cdaf83ebb533"
  end

  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *std_npm_args
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

    Open3.popen3(bin/"purescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
