class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/1.1.0.tar.gz"
  sha256 "b726026bacfa0214a9cace239c9265cd78e66821d25de40bb2abb7305703375a"
  license "MIT"

  bottle do
    manifest_sha256 "22e53ae92761ee38f2a0d401cb2e06beb694d3e378e2cbe8509956a960af87fb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbac1e072fc717c8c8e2d56494b98506348a50bd059f66a3fa0d6e11f589d7a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1dc882b67f29f0bbbb32c59cfabd9ef18382a42c552e31166b44f619ddde1fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb47dbd5242dafb910ffcc2f42031bddfef55f209218ac615f965abd2307ca17"
    sha256 cellar: :any,                 arm64_linux:       "1ecb9a9204010ea07afb800fe0dd0efc6c8a27b632c97b049a64bb71e53be21c"
    sha256 cellar: :any,                 x86_64_linux:      "c07ef1297d7310e8f24617fc28464bd5f3868792e667429497c2f98bcd72c79a"
  end

  depends_on "rust" => :build

  # The PHP standard library stubs embedded into the binary, pinned in `stubs.lock`.
  # build.rs downloads them when they are missing, which the sandbox blocks.
  resource "phpstorm-stubs" do
    url "https://github.com/JetBrains/phpstorm-stubs/archive/2049ca3cfa1feabf52db074108fe776a5713cf02.tar.gz"
    version "2049ca3cfa1feabf52db074108fe776a5713cf02"
    sha256 "3ef62542d2f77ad30c7dab7dfa726e57e86dd5e3403780294119cf4f5ca6dcb7"

    livecheck do
      url "https://raw.githubusercontent.com/PHPantom-dev/phpantom_lsp/refs/tags/#{LATEST_VERSION}/stubs.lock"
      regex(/^commit\s*=\s*["'](\h+)["']/i)
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    stubs = buildpath/"stubs/jetbrains/phpstorm-stubs"
    resource("phpstorm-stubs").stage stubs
    # build.rs treats stubs without a matching commit marker as stale and re-downloads them.
    (stubs/".commit").write resource("phpstorm-stubs").version

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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/phpantom_lsp --stdio 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)

    # Built-in functions only resolve when the stubs were embedded.
    (testpath/"test.php").write <<~PHP
      <?php
      echo in_array(1, [1, 2]) ? count([1]) : strlen("x");
    PHP
    assert_match "No errors", shell_output("#{bin}/phpantom_lsp analyze --project-root #{testpath} --no-colour")
  end
end
