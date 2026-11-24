class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.12.0.tar.gz"
  sha256 "094d17ebd1457571ffa0c75de165303495eb74a902efd0c3d1f5667975a797ca"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    manifest_sha256 "127c5f4df6adf7f5f4b6d0dadd50e56690e6da57ef8d1f017f074100c76bf2b0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "973251f6a0f7185bd2fb3016329bbe75850ccfeb3031a11f31150c1f272cbda9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e48de0a1a6f7af8dee950391e9425e13b429f399490c9bc24fdbaf3ef5bbc78d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "583f61f17500bac8397b3cff304f639796d22a231930df1b5d9471f407809bc7"
    sha256 cellar: :any,                 arm64_linux:       "6998eb6d51fed62f8ff406a071275961415ae5f090d733ee596bd6bd21f6cd4c"
    sha256 cellar: :any,                 x86_64_linux:      "1ee5d604313f039c8fb40168db7ac990e53ddc49f1093a6179ec054ef0df2e49"
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
