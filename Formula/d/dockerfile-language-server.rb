require "language/node"

class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https://github.com/rcjsuen/dockerfile-language-server"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.12.0.tgz"
  sha256 "02ac128649abe554de722dc45090bf7c1cd2770fc7597f65f1b73571f2d3d87a"
  license "MIT"
  head "https://github.com/rcjsuen/dockerfile-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036ee1fea5ae2faf37be1a72d4bb7cbabe1e3e5c38f790ee0586f130364a37c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c78531b193726a9b6130b8c7e9de29192c4c4a37b3037e1b920747b20fe8a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653dbd6a9f9a8c341c210fd8ad030c1c73ff83abd4e465df5a315fbebd6e5a6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "daf6ccfe5ee534909bc62ceb6f5c41f957a29c5f09c8a947a9c729ebb5ae33bd"
    sha256 cellar: :any_skip_relocation, ventura:        "59494f7b7c09cdb637659a54f97caef64185b3f64396386e2b7d814b53619e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "18458522460177a1276155c765e637b45da465d00a6d370123a16ba963a1ee4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47f572f5c1a42796f2b2922c93b49291342d31cd67d9bb21e1a47aa31de4e22a"
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
