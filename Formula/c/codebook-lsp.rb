class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d0ee5f1003094d7a08be0ca08061b893de7442d552dc500997e089c832850d85"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf7f6fab42d896a2d4ba1f7936949eeee8213c34b3538c4a16af90aa2ae76bd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e54c0ac35aff17075b2f2f01e948e914ecf0fee0a9ae0e241a33ef326d56e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5304677b110c5508faef049f96667ae749255a4d2585519e22b49f28d4dd4f37"
    sha256 cellar: :any,                 arm64_linux:       "b93aaf7e4d1abc4cf0c171f4504992290f1f4ece06e06da6e7d94da715294109"
    sha256 cellar: :any,                 x86_64_linux:      "cf23af009f8d63c3b382f108603f0e181ab258a0c10218f88ea6065589bb40ea"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
