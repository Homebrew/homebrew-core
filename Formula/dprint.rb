class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.18.0.tar.gz"
  sha256 "5e0a44b0c46915d91eb1bc6e6d68f72bd3d90a39875a9368f9d39b27a3feb161"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2274645ef91f18baab7ab1dafc0a0dbcc4bfb5a2dd0b120fa2328f0b644e7733"
    sha256 cellar: :any_skip_relocation, big_sur:       "45a0b8f82ddf8556487d74d475bfd33bddddf31236885225494ce7bc4e98cf22"
    sha256 cellar: :any_skip_relocation, catalina:      "a6f3af896729b117b087b80f292031f9ff51b6bcf813bed0ce28e94bea7a1c9e"
    sha256 cellar: :any_skip_relocation, mojave:        "fb1702cc211c5f4b3ec8faa5401fdc7bdcbd72383a2ef4f3f57f99dc5cfb278a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a365162f62d79035a772629ed3156d94b985b2d5ac5f0553d198362ab7fd2c81"
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
