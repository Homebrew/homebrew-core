class DockerComposeLangserver < Formula
  desc "Language service for Docker Compose documents"
  homepage "https://github.com/microsoft/compose-language-service"
  url "https://registry.npmjs.org/@microsoft/compose-language-service/-/compose-language-service-0.4.0.tgz"
  sha256 "09164b4226078de49324440411d224a89748f1b894d0989c7c11d9bd45d53215"
  license "MIT"

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

    Open3.popen3(bin/"docker-compose-langserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
