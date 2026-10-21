class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.10.0.tar.gz"
  sha256 "a3c91860a0f35b76ace3d1f4a06de9caa3757254fa31d481bc6d10476ecc7c28"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dbe678a6210968cc45a2292cc06e462f832f2bf2fef830a66b73092a58caa7a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bab48c09602d45caec62a2d07c110d897f91b53cba098962a38c789249c06b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b61f0fa618f8f11e42aa05df8dfe72d58eb1a08ddd268d6a7f23e4c6c361d5e"
    sha256 cellar: :any,                 arm64_linux:       "dd94fdad8168d7dd09dbee5468d2e72fd026ae93d38b6359158b0d97531502a2"
    sha256 cellar: :any,                 x86_64_linux:      "5c2c92919ffe3fb76589fbb369c4ac04e9aca9aa78e228eb70faa9e815bd7472"
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
