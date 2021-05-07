class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.13.1.tar.gz"
  sha256 "1de98e2e629f18e9ce1ee2d7858520b120b823e615ff4be1da60bb2f0c67e964"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c476c9602ab18481e342416ef812be18ecfb8748114373d689b4d7e545b32d2d"
    sha256 cellar: :any_skip_relocation, big_sur:       "98f0f16fd55f1a3a72d4c3917b3d7670fe9efec8f25cdbb2655022e7bea00aaf"
    sha256 cellar: :any_skip_relocation, catalina:      "1a648c31c3692f26549068354180e498f13463601fe5da2c260cf2d7debb0aad"
    sha256 cellar: :any_skip_relocation, mojave:        "2fc502930e0f243358c4a97a1ea90a87cf8f2aaabab6fe24797ec5323c71735e"
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
