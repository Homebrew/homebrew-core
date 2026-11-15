class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "a209ea43c2ae6b0c1273a1cac8f6a8e1ac5f7e2d43c18160fda0690ea0656890"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f633deb23fef675ace44a63d47d456eff6ffaeac9033f1280b88802668b1018"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f633deb23fef675ace44a63d47d456eff6ffaeac9033f1280b88802668b1018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f633deb23fef675ace44a63d47d456eff6ffaeac9033f1280b88802668b1018"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a84693fbda62cd933f841879ad3913567e6743c5dbccbb30fe6307546286308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7fbc475491d70aa02aafeaee45788506e54a271a6bbc08b81747d92a01620bca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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
