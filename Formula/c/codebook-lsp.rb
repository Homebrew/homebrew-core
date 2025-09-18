class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "89587fac56e82ed2d2e06f9b8dc061f271d1b1b0fb013550d2d39d696cedb4b4"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13141b8673d294e2317b898e80e2c1a65f0a1a096ec3d5d249c33cfd934f7d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e5b91f92e9d78a73a91acc4fb00e4ddc363d61cd7f7a7d2b8695f8da1c985a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb53baba938db6d72749d6deda844b8dbb02d28d3ffffbbaf7bad9fc87f0500"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc12af8c8f5eba1bf40b976bd0e83b0f709349198c7f08694cab50847d2f2cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf6ea1f533120555161d5321fd7d24c622f0140bcd4b49d9be1ee2ffe8330a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce47afcc402a29c71e7f32cf283f6e98b05f46a3ff1699eca444d709a32fd73"
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
