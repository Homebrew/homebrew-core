class ActionsLanguageserver < Formula
  desc "Language server for GitHub Actions YAML files"
  homepage "https://github.com/actions/languageservices/tree/main/languageserver"
  url "https://github.com/actions/languageservices/archive/refs/tags/release-v0.3.60.tar.gz"
  sha256 "1fa7f2383c5370a541e86b444e4e82a9a5a8e237d5c59b05bb6be48a1f501259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68081cbdd1c49a4cbeea4004bc99dffc1274b59b55165bded937b8c2950f1ed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68081cbdd1c49a4cbeea4004bc99dffc1274b59b55165bded937b8c2950f1ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68081cbdd1c49a4cbeea4004bc99dffc1274b59b55165bded937b8c2950f1ed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "68081cbdd1c49a4cbeea4004bc99dffc1274b59b55165bded937b8c2950f1ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba3acc9cb98f379d6e63cadde4cf3611406f33aefc7cc6658f1ffefe1d4cb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fba3acc9cb98f379d6e63cadde4cf3611406f33aefc7cc6658f1ffefe1d4cb70"
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
