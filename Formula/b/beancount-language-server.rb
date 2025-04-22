class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "d1da21e518815514ebb1d69e863dc414ce6480ab0eb81e113edb91fca4a5d999"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0c99b2f1dcb24b04cd4698c3518d3cecd0546aa374dbb6c6cc5887fdcd2896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648544219f5a5e8c470f7ff408b855d1fce73e2755b99126d3d097d6638bb638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "556f325fb38bf9bffdc52b3b9e7fd88daac37560b78ceeb28efe389b2df9fd9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97d0cc203492c1a4a1f23b5b511ce7201866c9ac85a33c1801903549a7ef358"
    sha256 cellar: :any_skip_relocation, ventura:       "a30e3c99c240779b2f31ddce88ef5e7ab090998b27d33b565802266f0e7db114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3ffe95aa88c9d22d101033c5c890c960e3c758bce8f19850f1a7180018e0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1e6d556a63559ec5d98de3cc85ce144fbd5f9d4509fc8020bee4d69a995a4f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
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

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end
