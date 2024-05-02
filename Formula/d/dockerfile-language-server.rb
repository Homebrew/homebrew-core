require "language/node"

class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https://github.com/rcjsuen/dockerfile-language-server"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.11.0.tgz"
  sha256 "042cbd1fb9baf818bf5eb0730a45a0ae257d42e74d358c8bf177f5a561f3839b"
  license "MIT"
  head "https://github.com/rcjsuen/dockerfile-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7110ccd0518d69ff46216bebd74f2435570aa1f41e78321ef3d187e9e07f195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7110ccd0518d69ff46216bebd74f2435570aa1f41e78321ef3d187e9e07f195"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7110ccd0518d69ff46216bebd74f2435570aa1f41e78321ef3d187e9e07f195"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a84133e59a27c4c865fc3ca68782466015987894ab94bf708a42543977c3a56"
    sha256 cellar: :any_skip_relocation, ventura:        "0a84133e59a27c4c865fc3ca68782466015987894ab94bf708a42543977c3a56"
    sha256 cellar: :any_skip_relocation, monterey:       "0a84133e59a27c4c865fc3ca68782466015987894ab94bf708a42543977c3a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7110ccd0518d69ff46216bebd74f2435570aa1f41e78321ef3d187e9e07f195"
  end

  depends_on "node"

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

    Open3.popen3("#{bin}/docker-langserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
