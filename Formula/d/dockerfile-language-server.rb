class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https://github.com/rcjsuen/dockerfile-language-server"
  url "https://registry.npmjs.org/dockerfile-language-server-nodejs/-/dockerfile-language-server-nodejs-0.13.0.tgz"
  sha256 "2e6a287dcf5de6be2a1c01f149a8c3717fa0bc8a689cc355d94198081779d067"
  license "MIT"
  head "https://github.com/rcjsuen/dockerfile-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fc0733c32b23d413bc930039532ba81099fea104efd7e50c5ad87830bb52bea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0acd811cad164eaa55ff4fb328759defae0ee5c12995cd11fa2a2688615fbf53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acd811cad164eaa55ff4fb328759defae0ee5c12995cd11fa2a2688615fbf53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0acd811cad164eaa55ff4fb328759defae0ee5c12995cd11fa2a2688615fbf53"
    sha256 cellar: :any_skip_relocation, sonoma:         "59e9066fafdb05c780c640814cd2aeec5180f8ff184e61e60dda6c732164b8fd"
    sha256 cellar: :any_skip_relocation, ventura:        "59e9066fafdb05c780c640814cd2aeec5180f8ff184e61e60dda6c732164b8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "59e9066fafdb05c780c640814cd2aeec5180f8ff184e61e60dda6c732164b8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee4c193b8f1eabb362140936b430f8e8138329a9e164cad55ffeed21ddd827f"
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
