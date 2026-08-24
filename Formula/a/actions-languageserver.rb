class ActionsLanguageserver < Formula
  desc "Language server for GitHub Actions YAML files"
  homepage "https://github.com/actions/languageservices/tree/main/languageserver"
  url "https://github.com/actions/languageservices/archive/refs/tags/release-v0.3.61.tar.gz"
  sha256 "90f142dbcb032afcae9b6530646ac168c4917a48170c824761b969e155cedc00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e572d3013c3b5671d3489f3bacb47ee54b8a78f1a693b4f72b4efca8de77ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88e572d3013c3b5671d3489f3bacb47ee54b8a78f1a693b4f72b4efca8de77ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e572d3013c3b5671d3489f3bacb47ee54b8a78f1a693b4f72b4efca8de77ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "88e572d3013c3b5671d3489f3bacb47ee54b8a78f1a693b4f72b4efca8de77ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a5fb6a1160ebf752fef750cd4caa7c8bfa19174758969d6afd2d84b5125266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a5fb6a1160ebf752fef750cd4caa7c8bfa19174758969d6afd2d84b5125266"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build", "--workspaces"
    libexec.install "languageserver/bin", "languageserver/dist"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    require "open3"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"actions-languageserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
