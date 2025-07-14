class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.10.tgz"
  sha256 "8658f4568796fbc1736774c332b6cf8199bf1218a32297930153bb1a239cd2e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23292848f5b3230a81e645579c4b63ddd5ffc2b112fc5259d06fcfe6170555c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b18fa128084adb15fc202f0c92f9ef0331212bda442f2c624ae09e1049c627e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4edd3d72f56ffdb29e2d0c5089c034ad988b27efaa85f7cc80681da792f3352"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a48c739199547813106e6b824c7d704d3ff44e07ab072802b4b05da3c18db16"
    sha256 cellar: :any_skip_relocation, ventura:       "90831422f1f2d1037b8580a3c8647179f229a050db49f79eac187789e65bf33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7825eb104d5cc6f7edb48eba4b40cd899bc5e89fda7e4cde32de2bc8eb3a9e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0a041d4dcf3478cbf99396dda7ad0865b0186ea31291fe75043f40f5c4cbf5"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    # tree-sitter<0.22 fails with clang>=18 but is actually unused
    system "npm", "uninstall", "tree-sitter", "--package-lock-only"
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
