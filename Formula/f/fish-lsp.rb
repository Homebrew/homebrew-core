class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.9-1.tgz"
  sha256 "c28799ee8b7e3a17b7892aa3f9d80ebe638313b9bce772ac364faee3ced5d43a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd0aa44217f04dce7a0016c07e1f232552092de2958a862b3dbba59ff98e5d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31e2b3079d69b9d7f960399e6ff205aafdaacae5c0d9e39bb8ada0a17a4b2763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391c5738ba7d009359573d185d550c9ad0f838eb6089de88e1598c373532b738"
    sha256 cellar: :any_skip_relocation, sonoma:        "768ba6503c8d30a8d32c58fdbbd5bf92dd38ccc7d969a8423a24e68d77c28499"
    sha256 cellar: :any_skip_relocation, ventura:       "cd00a2257cfb0ad4288201717a2d731d0b0b77709a169efca97c2c55460c8d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "653f8c99ce4ef102e2a428dcd2168ace89f63b090819f8c62f8f91267de2046f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d125c5114e65b3a8b767b686a5f9d91fc12cd81c35a67b3d565c7310ece8ad"
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
