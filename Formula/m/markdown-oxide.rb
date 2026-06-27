class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.11.tar.gz"
  sha256 "274446b861ebbf3098dcb7e0a5d3135df88df34b16a2c128288f900391dfbf75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f76bf140c6723068ad12b83f04fe23a75fc6ed18f5675e2026f0e4c13c32f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207164b6f4e8ea2029a03e13e5dbe8dffcdaf7f9a7dbe9c4fa65bd2e07388ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c230ab62fc892aaf1b633e294ec12fe01a17f02aac863ded63a2a7a9cf1c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ed32e1ad3cd20e40112e680c38b66718aa2d765641cc83920a910537789825"
    sha256 cellar: :any,                 arm64_linux:   "bd5ebddfe0bd6dcd90fe471d521fddbc7a713a72649972bc41daa5106e9bf689"
    sha256 cellar: :any,                 x86_64_linux:  "680c99e8884b9bf3d11f965ac96133dea7af2474b17bffcb137a04c3d06fc283"
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
