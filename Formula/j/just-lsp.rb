class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.11.1.tar.gz"
  sha256 "da7d24be42cf8cd3d736be7532c71e8229f9abe208d3e52676c960fa0fa67fd6"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fc7370608cf24c84dae1b0346ee5d22d136b00be783eb3e2712a9bc5c2295f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23d5b1c4d0be4179df46b3f0df907df38602f4d0642c47e5bb9272967be06d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69637cede42e7ddb42e53f1aa11b1686554b734dd4f88243967b40852bf2813b"
    sha256 cellar: :any,                 arm64_linux:       "866fce89663dbce6302fb0d41076565563aed362c9f857bd2e59c29ce1205537"
    sha256 cellar: :any,                 x86_64_linux:      "7976915d2439525832dd2549a04d8e1b91a2450d885e4f3c569cb0cbfb95b1bb"
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
