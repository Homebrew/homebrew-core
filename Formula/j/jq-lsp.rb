class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "899cd2dcd4838d21bab1d84f687cb4a907e0fce7702990dac342b9b6fd88b5a2"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47061ca69bab6c5e7f237e325b3fb2cbc65a0c5ce8c1bbbb23d8be1e360f1522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47061ca69bab6c5e7f237e325b3fb2cbc65a0c5ce8c1bbbb23d8be1e360f1522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47061ca69bab6c5e7f237e325b3fb2cbc65a0c5ce8c1bbbb23d8be1e360f1522"
    sha256 cellar: :any_skip_relocation, sonoma:        "767cab6e7d0b1bad5d5123f2349fb6a2d9b11592e8d0df2b7f7694354d007d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7b0cb9205d7951db329ce637008f3b0dfeeb3b589318d7c0c7670c4ff36869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ad43fb3ff4ebc8e333e0253ffceeedb37b26f9f6da1d31fc1c719dd9a67322"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"jq-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
