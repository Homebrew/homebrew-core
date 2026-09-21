class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.9.0.tar.gz"
  sha256 "b9fc878286b054b630c48e458f09f47dfb4cf6047cae2636225ab66a378b8773"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04db6a0204b723ba09984fd8d7d18eaf826a6c13bbe2c1a03ed9823ce3b9eb6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6006d7ba743bef2eae5e2e2efb68118532c9ab8f7d1afb305c68bd013e27e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18c771a800022899402bc6994f9c71ddbee61de3a6232a1b33b3b31f26dcf937"
    sha256 cellar: :any,                 arm64_linux:       "bc3ae0c747d312d805cd95a870778718049d90f70a53ebb19f4a64d3302f6004"
    sha256 cellar: :any,                 x86_64_linux:      "f63f2412042f99801146f8b75f45a0df23eb4933a78833910a8af7eb433aff9a"
  end

  depends_on "rust" => :build

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
