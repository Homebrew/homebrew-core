class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "2c711aa5f191de202b8496f397b74403c252a6fefc47e69dccc3f335972cc14e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de9a51f1ad3805fbcd2788ef966ec5689beb2c8e2c3dc45da68565208c676e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15c0d7be3f8de4d1a75407bb7b5ae4521edbfb581411fd84d072f6e57c5efc26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cd3d13fd7aab27c124a6aeb1ea3cfce9bb01b787143687480f450ae699c66e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "756a5a988edc724638d826f909acaccf2595244d7c9b68a3750e58bcdc96f85d"
    sha256 cellar: :any_skip_relocation, ventura:       "9f59ed0bfa0121cec2ca7cd9184cdc88ba3d1e7c011621be4bfed65aa99f0476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dba7466889612e1c2876bd03ae2533e4ab9a178b72f46494a5f59fe438b87d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77247a34ce563268c068275123ef43abd3e32f9bb9ac034c962cf351c8f4f61b"
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
