class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d9f5a1bda4a67e61ea0650ccb6ebe2f143b884e81cb5156d4cd0726888d2191c"
  license "MIT"

  bottle do
    manifest_sha256 "d321c1c0670488fdb2d8dd84d6e41cdcf48796bde83ea9a631345d0f276da69a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d4a8987f57cbc79e71a9a861267b622e43f74aa079fa9da9a8e0e779f1c0506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86e69d48c515b1f4a8af4dc6a1e0d43b0023ae220d31a897d22f3fee93f160ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db17cf72c13f48f440b9a6436e55de0971b05fe2b2e330363f3252f8f2520dfc"
    sha256 cellar: :any,                 arm64_linux:       "3707ece8a6de71a81f387a90f1c1e43ad3059f2bf1017dabd0d48e8fb37f2516"
    sha256 cellar: :any,                 x86_64_linux:      "0564ed465e02e1096657204e2f239ac99e1363167c1bb8205e9157d188df8976"
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
