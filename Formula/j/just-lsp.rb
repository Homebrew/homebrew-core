class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.11.2.tar.gz"
  sha256 "1c79704097b7fadfa9ccfd8c39847841e15d9a33433ac7b01023eff0534a6700"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1579a11a33de080f4942db3ebc81b02ef71df6d106d53b2ac2ba6d13f684d819"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74ded5b6933a9b55f3f03e19fe6c5308799c6f947f94563ded92bbd22fda3e7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3be011928a6fb5b70e64aca16ef22405046f8f4dc4c9f7ce316089f2fd48ea78"
    sha256 cellar: :any,                 arm64_linux:       "0002abfc9c456efcc03d134bf928c39962adf35f7c84f01b1274a2de82b94ad4"
    sha256 cellar: :any,                 x86_64_linux:      "394028a4d76a8ab8606c3367ebe66f6e54b550ba7a8cd0c2707299a6203b45dc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

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

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
