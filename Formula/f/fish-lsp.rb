class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.8-3.tgz"
  sha256 "54b36663eb1ae807969d30399189285cea578d8b65e8943705601a98c81ee4b6"
  license "MIT"
  head "https://github.com/ndonfris/fish-lsp.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "262affd100aa67d1959987036404ee1a1da277b5e3033ebf56f0add5152f86ca"
    sha256                               arm64_sonoma:  "cc5d172d38d3e7cf02243da09f0269478abd5da536eb2c3fc6df0b69cb232f4d"
    sha256                               arm64_ventura: "dee73c808f55636618f4d2794ec1def3bfff0d0ed24c5166fe817d1e27f2076c"
    sha256                               sonoma:        "b0dfe36d799467431c8cadbdf830cef2ef82337005e4e59f6f7119172e3899d4"
    sha256                               ventura:       "9015110d31f885b970a44fe7c735aa17166a595b93f70ccd2ee376cc01dfba21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b261fb388f3f2d5ef74091c9292bd4689a7fce09dc590b7ad15ffda20b7159"
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
