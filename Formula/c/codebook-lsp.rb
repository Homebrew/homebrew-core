class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.42.tar.gz"
  sha256 "1d625f648ea417a9e336a7f6e269065f30c6fca95615e0fd35877cfd3e12058b"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba0081938e6f4872d4bfc33b453eec983b8942c147ce52ef77530e985335ccbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2574c737b0b229ec36fca665330da029153cec98d5be6f0c74357de5859f62c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f505d7f3478727d4c5e33b6e3c067152ff42459ab328d6d1b0b23801d1b9d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed7a9ace3f9eca73df9bb288e953a8c9ebff0ee0a853721f464b735ab373587"
    sha256 cellar: :any,                 arm64_linux:   "6f26c3f405eb929bd7b71b612bdfa9bcfec3aa49591d629ae7a9642332a0d9f5"
    sha256 cellar: :any,                 x86_64_linux:  "881a3eb2bc08676dd90344b7a555ca62800dddb1c691092b2c09067cedb8db79"
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
