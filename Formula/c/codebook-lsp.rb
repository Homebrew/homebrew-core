class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.35.tar.gz"
  sha256 "fab3da80acff219bedd58117b399b9c80cf1b3d18b62f270a07ae60a49d72e99"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "206539c0af20de0d1e688079ce89b1e87395d52a907451d7f9537e68dc7a5da1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b703966442e824cba7f00918d6cf3e4b2741cc7db85c2acdee662a171cd30a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcb0031a99daaa6aaadccad721cc2cdd20c8e301317bd0091310f3bac5da046"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b50244e5f1f6bdf75cc3a721e63e91c521d43ab77be9f05ce6497c9e96e5222"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56aa3e70fdee3fb305ab25ab99ec7ac074ade079d74af8114a3cf9f54022132f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5dfd1c6b19ce11a77c1db03ed10a79b6620c68dce72203e263130f6774f3f89"
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
