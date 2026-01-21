class PonyLanguageServer < Formula
  desc "Language server for Pony"
  homepage "https://github.com/ponylang/pony-language-server"
  url "https://github.com/ponylang/pony-language-server/archive/refs/tags/0.2.2.tar.gz"
  sha256 "80697b23d7aa8e98a474e4aa6cb552c59171217ab0fa400c9f912fa8a08d0cae"
  license "MIT"
  head "https://github.com/ponylang/pony-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f60d5a06961779fc4e76ec4812e0dd5b5f2c2b47e0ba5de68ede41e7a9145cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2fd0cb00af203cd447072ca33793e773b2e10cf893568b8bdbec29b56456d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e32a0caa61451f6c6ae5e7817be7a72db317932d33a93bc3c3b0bdeeb8d558"
    sha256 cellar: :any_skip_relocation, sonoma:        "11b338e57a2671b0187a4ef14332ee6729390dbc5d3497e8a1fd7392c203ab77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee42c413ed4c9377b2277d93dd955c5b17ade08ebafa47d2e0d8d27b36ff612a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364ecccee334c255b515a75e868708a6c0ac4e0eb4cfe1ba98db7fe46fc29874"
  end

  depends_on "corral" => :build
  depends_on "ponyc" => :build

  def install
    system "make", "language_server"
    bin.install "build/release/pony-lsp"
  end

  test do
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

    Open3.popen3(bin/"pony-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
