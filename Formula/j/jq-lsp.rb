class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "186d36e92489304a46036ad51ddf411b7ae56a2fd8af8593cb6741c539634f3f"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09c79acb05cb9e4335539bfc4242b916653bde8865c949e946a3bc8af4e83f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09c79acb05cb9e4335539bfc4242b916653bde8865c949e946a3bc8af4e83f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c79acb05cb9e4335539bfc4242b916653bde8865c949e946a3bc8af4e83f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a56d08e611df4605462f85642ddbb49f5a7e2f641a0bcc959bab998bf0ac02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9080972df1a891839e9b05a7538fb132bc4691dbd61cf1b0810cbccc7b4f9d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab59fba5da057dfcc78364381ab05537220a1e00c4e3c2c956baf6c93687f66"
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
