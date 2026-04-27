class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.38.tar.gz"
  sha256 "9ed8e61d7d6b0a02a0d2495bc6f4f31884d955d1d24f8212a8a385312d2faf3e"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262b237d9f2cb00f4130c6fee08c79ed1b3f267b50ce7c7547b0cf2dac91a54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1786f6f3ac4451e24e020d853680717f03782c4ddcd57985fc377fe6fcabb207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f159319a20d990c7df7cb064324a22d364b100784b3c09cffb9fc77dcd904595"
    sha256 cellar: :any_skip_relocation, sonoma:        "605d5ae58003a67de4c498cc24485967d17d18f3b609b843195bc2514146e02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d15d639ea000f8ae83c78e88fe93826744f331e9f0a5eac3dd9c6f4c367560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a4fd588ce02ecadfb9f13a963ad2ebe7724690d72d43fb64b91d8e99d3a8c8"
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
