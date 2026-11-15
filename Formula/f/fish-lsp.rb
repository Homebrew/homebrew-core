class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.5.tgz"
  sha256 "2fa71212c2e0eefae779c97a596f760db008a08878758887e37c86513fe83258"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "614c08f5b75b2123c83e3d98bc134f89d328a1755e94cb4a7f8464dd2221f192"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15a3dc930fb05216ba3a018a0e1d23b99f479583c91bffa4edc5bb8ab50af501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fef8d6e569de2184a5a779d0ec699b11950186757e8569eaf007e6592f44468"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54d885288c48afc29251a85dc2bc4cdbf2060c93ee3c9e71393c6b0b94a749c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "47f64045c6b6057f6eba0db59239d2ba81d9eea748ea0de11544d72a52dd6891"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "man/fish-lsp.1"
    generate_completions_from_executable(bin/"fish-lsp", "complete", shells: [:fish])
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
