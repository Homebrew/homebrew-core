class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.8-4.tgz"
  sha256 "5ab1efa4a3a28f97e934bf1dc7ba56347d6cbadd3817cbf3839e333108170597"
  license "MIT"
  head "https://github.com/ndonfris/fish-lsp.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "209730a654962d09739a4e856b1667c2bb906bdb47571524103cd7d0c2c749e4"
    sha256                               arm64_sonoma:  "7f32277b57118551a0198478158a56538947b9100eb7a53a483c967c844abb06"
    sha256                               arm64_ventura: "31e6c98852b8adeb4ea2ba717edf1d8fe04afc772413abd68b78e4aa142e429f"
    sha256                               sonoma:        "79eee676c4795956f596e2f2ca2799efa538ecd27e88bfd2775c5dca569e9fb9"
    sha256                               ventura:       "e8d973d7d5dbd6662a91c30041f17d4e637cc037dee2d29c7b77654856bf3ae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22ab8ec99fe8a6e45a2ffa865798d135a850c793d5c0c251ad92932c494d70b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009be9dbb5e8067f447680e1dba278fc7b73d84b222925253e207446487ebe97"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "docs/man/fish-lsp.1"
    generate_completions_from_executable(bin/"fish-lsp", "complete", shells: [:fish])

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/fish-lsp/node_modules/tree-sitter/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/fish-lsp start", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
