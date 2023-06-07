class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.37.1.tar.gz"
  sha256 "15fea45b760987427bc68a9da6d346b777ca0253d3f2a1c8cd2f3a584d59c7c1"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb3ccd50bd0ea9cb58c44f6ad45492ee5c773e643494e45847794a486624e677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb6f8b12734e010c10daec30d7f49ae2e141df4c671aab2e0c1d29d199450b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a444a83beb54b5413f1aa8913325ba4169c7c14ac09ea36dfa8bb2b15ebcd0ba"
    sha256 cellar: :any_skip_relocation, ventura:        "898c7063681e691414e2e7c2115a28cce2a6526a1ae8ef26cf252f20d1b625d3"
    sha256 cellar: :any_skip_relocation, monterey:       "d7461d49a4213910496bee658726cb5c34f4033d76ce40ed60eb6cecca1f56f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "65ca30ea3578bf5a87462bca6919d91930095502819f8b6d10e2e376d3708815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678d1ab0251347fa0d44f7ab6726583620bfae62ee0513af21a23e5a0a81b649"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
