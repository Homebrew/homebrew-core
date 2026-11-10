class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09cd3feebf7ec75175d630740ce011a49ea8566cdec4930e4fb8964c5ea6afc2"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc1afb749beb562eaea62660718efc3ae6c0818c92edf2ce774a66498a43cf32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98a89ca0661016c81040f86e3cfc6837871cd52e44b94facfbc8453e2c4b1439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d25f260d2a5ad3d42e43fc7a815ae4010b4b088b0906f9d870322ad5a3770dd"
    sha256 cellar: :any,                 arm64_linux:       "187d32ea127900077b4e63b105c0614b3b1ac6475ac0fa1db54cc4187f38a987"
    sha256 cellar: :any,                 x86_64_linux:      "25611219aa87016831c08506455850c9ad69fab9f7c09c9c7980ede1bef0877d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
