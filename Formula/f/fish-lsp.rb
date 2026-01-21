class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.3.tgz"
  sha256 "1579b9ff599a46fd9d1c276eec1b6d67dcc5cd45cb6637d776e7912794f2fa55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "201dab806604b73ba3fc768994a068d6b690fd461b4c0a34ac525e6f146ae9af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb11ab4f3df4006699a25c212ecd542dc793a227ab7f63ce08ffe8ac70bf8dd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a5d288e4fe733eb8f8c5e6f889144df95d51557b43df2372544dccfc7209a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "61faa3f547a6236194f97ff1be7e9b9b29a5e0fea3487b5305ba7ad68f6d590c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81fcd3fda13c220f8cd5bb8a6c2a3e35c1a6d62919af172ffa1e2ed662357d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e96b735a5eca4159c0b77327b17974c1293835e2362789868af9431a85b0dad"
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
