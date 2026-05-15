class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.39.tar.gz"
  sha256 "f5c1782f36b860f52465886b66fc6fa9f7973c5ee3f828fe5348998a1b915f27"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab92b057a815495b9aa45ad14960abc41ad1cb7f3af28653cca9557b447a565c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f0f55effb3d643d4384fa11dadf42cfd42ac3e3155a189c8c3e5520fac1cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ce9d0bb63e5089edf4b2cf043cba3297c69fea28008d374662e3ad9652961d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f05a10010d4403ff5007ede59d1fc9def649702f1147c33834ac89bea74a9d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e39d89ec2c62c0c7e3a65720c7850ac28daf37cb0a0dca181223805526d9624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4802cfe41286f5ad294cd70bdaf8b53d7468f6afca163f71adfa487ffe346479"
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
