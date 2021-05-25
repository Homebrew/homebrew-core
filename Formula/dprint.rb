class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.14.1.tar.gz"
  sha256 "b45593a237f0428c9999faf0b5e06973336b9065ac1e263c7a816342c7eabf7d"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e92cce1cda2ee8d0d1b5704ea8f9ebcce5f41e53186e28f30ac8896af0702e0a"
    sha256 cellar: :any_skip_relocation, big_sur:       "494bbfdd45be8f4be51ed6ed573f06fdd73518be4c7aa5d1ac0b93cb2f98c17a"
    sha256 cellar: :any_skip_relocation, catalina:      "def5eeb143f6413022e94ec03bfaf17f0a13fb45121c13599d0cfe6c17f18b25"
    sha256 cellar: :any_skip_relocation, mojave:        "26e47d41e325713f63d6451f49ae59aad911d08d937b8abee3a51e1f74aa048b"
  end

  depends_on "rust" => :build

  def install
    # replace `--path` arg with `./crates/dprint`
    args = std_cargo_args.map { |s| s == "." ? "./crates/dprint" : s }
    system "cargo", "install", *args
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
