class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "7add54d84ae75d0194e5834f42608c0314d33a9ce94f589d557e0f3647d223b2"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160630699034ce3439b40fb741c7ee93b673b7d2614866206541da6029e44ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c356d38291632baa129176f99c435356ba8c682b97c2cb115b5e495725237f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ce6912f0d74876097f65e98430bcf4ad5303964f3da87b113553806b0dc2c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3995f957ad7c5e8fad02634c2a9aaa78d14ca83f151ac53a296fab5ff8bf4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d73fad2e809cbdf734a3adfdafb9bcbbbfdabeb61a4aa98e019cdcce9813e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7857f69eeb5c928b78eb2f24be55c2fe8c66e5560375f1d15ae98cdb2ad52f14"
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
