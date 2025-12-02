class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.0.tgz"
  sha256 "91ee7d7299130fd253057db9b83c312723b0b079798f34dafbc3282685278291"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaccc5d2d540151d5c19e9cc7849848b5a3384cc25093a72862e2776b965baa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6955665629dcafed098c62ce6d6a0fbb906da71dc86225d6e1fb8cb2ec8086be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531a57dd0b420d750e087236bb4d6aa11f3053838101f597ca9eaeb846087270"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8a9c85f9bdf106392f6d03113cef29cedbed594379584b6789ca78e501b3ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1748178345d8deebd0e69eaad910ce0439f30272a3903e1b66a54eca47e7b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8816550dc9fff863b615ec74c585b41f5c6a13b2c4c4b699be04c441a38af1bc"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    # tree-sitter<0.22 fails with clang>=18 but is actually unused
    system "npm", "uninstall", "tree-sitter", "--package-lock-only"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "man/fish-lsp.1"
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
