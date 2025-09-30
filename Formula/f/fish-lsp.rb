class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.11.tgz"
  sha256 "81ed860fe70cc6f45cd68d86804950139a9a5c850efe473580fcb00af89f7a2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26e6c7abc10ec5e5a85798b0a8e1a9422b2e509da1c6055991139e9e94b33f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712284876dc0d66794bab0edcf67d17be8d98a19a33ce4d3d962c5fbcfccbdfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a88c3d18ecd9bd5e3609c219b511a16442bdc1db4b0a420112ad307ef846c72d"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a00db17e0a0b935f764fc29a9dabdeeaf83e729c3b21767ffd7c4614dec97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df4cfdf7ed0f38f3ed4502c4c3791d2332748667b87fc3bdbe7569fc56bbc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61887209fb33ec7bbb20ae01985ccd2b701ab18e930e93bbf0751932138568ec"
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
