class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "48ffd661d5b701f872b40e1aeebf12cb18a6da99a5967aadd92371fe88b20403"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0e07975d56c6c113a9d940a5939d09f9025c4ce2daba1a2476c6cba5057bd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbc9c4ce7a302ec9d11ca55b94036986d561320b1b5b843dcddac4f6ee41623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492fc71d81e3e786a12d3f939b207e4443e0a9e6cd7876cbc7a13906eca0ff08"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c019e9f894518eac458975438bcbc23195848225b8d2025c4c207227844e3a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5114b33ddfbd1631878ab498dbb7e39a5fb1a30619622142173ea83c2b55af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e70cd7c9d76cac538a86f7fa69bd11305e0d69ac7a0374c4c453d6bff8b271"
  end

  depends_on "rust" => :build

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
