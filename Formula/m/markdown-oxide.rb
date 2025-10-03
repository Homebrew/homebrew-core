class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "37fab5cc1b6accecb394568f963abaac3041f847a994c73e43d53a2cdfbbd0ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27af9f0e21275e2b705d86c706f0110bfe6fc133447e29191e703e0b72f6cd04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86daddddc9ca24abac239b25c298f7fe5af7fea053dc38cae9df5a8aa46ff9e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec897aa1e34fd924b28b20220ea4cc9c6678479692a992eae89efa7d07fc1713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f5035fe002476e59fafb0ef001318d954352e671b493c7f607999c8cb0cf399"
    sha256 cellar: :any_skip_relocation, sonoma:        "71289da00ccfd3cee5bc2b0b1cba8d6963bc54d7df638f4b46e4c99c7c9cc562"
    sha256 cellar: :any_skip_relocation, ventura:       "e618b4615fe081dfa6b0af7a0378cef20afb13d7d43b764d3a8d20b7008ac787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7afb80138f5ca1289b276c688dc7ccfae4d18e9a4b721c171d7f6acae941068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db001ba2ab41c7ae60f737522c8d0215239bed955cb3dcddb5a0382321aa45a8"
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
