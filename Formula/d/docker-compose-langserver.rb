class DockerComposeLangserver < Formula
  desc "Language service for Docker Compose documents"
  homepage "https://github.com/microsoft/compose-language-service"
  url "https://registry.npmjs.org/@microsoft/compose-language-service/-/compose-language-service-0.5.0.tgz"
  sha256 "2d6af41c4aabaa5c4fc89d2293eae6b561fc37b2c663a504000383394f715700"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a017c7c6e4396b8f8fdad2e301cd99df373af2dea6a6eb41f3b05213ca50ac93"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
