class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https://github.com/rcjsuen/dockerfile-language-server"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.14.1.tgz"
  sha256 "6c4d41b414e97a9f4b800cba92de0e21a6e494286761ef95a8ac7375559a5014"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d93ccb51f69dcfaa89b2dcd54b62d468a053adc4c9ffe382e7e1aff58e402980"
  end

  depends_on "node"

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

    Open3.popen3("#{bin}/docker-langserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
