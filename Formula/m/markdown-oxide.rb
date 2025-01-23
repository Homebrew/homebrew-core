class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "b3ff35cb6037cdf85395d5a9aa4823b88ffcf1cb4a5122aa8af8f6d8fac3b7b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be271dca49367889a71df1c32f5f4f00b02127c4ba457f15657f2501748b0922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf3fe7898b99c9ddb560485fd2199555780de25a6c5c1650cc597e7805a5fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3461a1e2f795cca29dc480fa0ba559d9b5cbc014df11a6af8f4a0c2031c7fbc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "43bec92b91c70dd25e03120e197313055e4f8409d80d4ecb1affd4e248ac63ff"
    sha256 cellar: :any_skip_relocation, ventura:       "576ab28b444d26f18b3c577de1418e4d40b6935cab8bc115949d1dd8e44607f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0becf69695319d0319914f8b7286d4540241904dc1faac40e72405f61fe11d1"
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
