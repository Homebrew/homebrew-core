class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https://github.com/rcjsuen/dockerfile-language-server"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.14.0.tgz"
  sha256 "2c2aa3fb4b1bea75701537a5e981f6001331308b930376e41305113edc4fe81a"
  license "MIT"
  head "https://github.com/rcjsuen/dockerfile-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6b490c6ccf09d9cf8136e67b95a9f12f350bc7ecd5f98b4d777c7b38baa631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6b490c6ccf09d9cf8136e67b95a9f12f350bc7ecd5f98b4d777c7b38baa631"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d6b490c6ccf09d9cf8136e67b95a9f12f350bc7ecd5f98b4d777c7b38baa631"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2d4d1a7357c1b9e25828d9f2da5444b4ed725fa16e91cf63583bf56310f6fb3"
    sha256 cellar: :any_skip_relocation, ventura:       "e2d4d1a7357c1b9e25828d9f2da5444b4ed725fa16e91cf63583bf56310f6fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6b490c6ccf09d9cf8136e67b95a9f12f350bc7ecd5f98b4d777c7b38baa631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6b490c6ccf09d9cf8136e67b95a9f12f350bc7ecd5f98b4d777c7b38baa631"
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
