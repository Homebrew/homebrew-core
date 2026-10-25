class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/0.11.1.tar.gz"
  sha256 "c5a9b0e21eac77edacd56add5b46094fb2425435581f32ba574d25e1ff6b97df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "233db00b3c0e4cb06da033a5fc8a5fe38d3a2387910f94e7f0ee1d086bcf8ade"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "784f0949c07965655e92c2b8ebd8f7e0190b75e1da1cb2d3967bd4ab6f1e74c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e23f2f99ce8c4ecfbb6c989879fcba4e348b478ba22e0e7b6b7463295a08df5"
    sha256 cellar: :any,                 arm64_linux:       "b2e353e783d6678f69a91019e62b8c98fff0fd87ce7823cef6720569032a23b0"
    sha256 cellar: :any,                 x86_64_linux:      "0a825339b11e18787927bd305943cded8e47e38016504263339046a1e8dc40e3"
  end

  depends_on "rust" => :build

  # The PHP standard library stubs embedded into the binary, pinned in `stubs.lock`.
  # build.rs downloads them when they are missing, which the sandbox blocks.
  resource "phpstorm-stubs" do
    url "https://github.com/JetBrains/phpstorm-stubs/archive/5f68c1021badebe34119fb8fa10ba7cc25de6c0c.tar.gz"
    version "5f68c1021badebe34119fb8fa10ba7cc25de6c0c"
    sha256 "8b9bf4b69196d9193f56a4a6ad88b9ff8a230e372312ae8a181c04df1972c4a1"

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
