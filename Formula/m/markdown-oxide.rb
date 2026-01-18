class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "67217dc2f460a21bf64493d2ebe860cb93563a62aa5eecc28c24cf38ee7100ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d94fc7f454689e3cccf6a3533195721ed31f2bdf44035a63fd76edab000510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c62677e78b51bfc6eb2c93f22be1f3c712abf74226a19af6798baf509afc491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32ff78a4cc7cc1e2712103147cd87bd17bcdbc2265a0135e67c89fe5f501b12f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5df3ccfd67daf16cf143ddbe3568c9662bfadaa1762fba43b192f7d4deafc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65366cbd11a81ff7bcc17a0d0b7df2a969fececa77b6504404c3502ac1bfd02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca06dfc9b71540e134322ed34ccf414b8d541555d0758201516d57cf30304627"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
    assert_match(/^Content-Length: \d+/i,
      pipe_output(bin/"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end
