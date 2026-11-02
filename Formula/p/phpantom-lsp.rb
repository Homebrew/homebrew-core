class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/0.11.1.tar.gz"
  sha256 "c5a9b0e21eac77edacd56add5b46094fb2425435581f32ba574d25e1ff6b97df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2947722dc0f320bf8278c7f1c6c02edee6bf75ac3cd26067add00717ff74db59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4922caa9bf3ef403d56e6fef64eeb2153cd792bd6b2378a81cc21df15d968192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0e17f27f74bd3b92ac52b7edff93bbf3bd0ec844901e1d603d391e52df93247"
    sha256 cellar: :any,                 arm64_linux:       "f17603d6cd860421d70337aa07faf0a2e3e7b5eff595c56dd3df3639edec655f"
    sha256 cellar: :any,                 x86_64_linux:      "1a083e44a4de8c4191248cda03b39ebd6105a398bf6ad79ff70787f2ca94f7ee"
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
