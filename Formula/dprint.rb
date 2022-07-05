class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.30.3.tar.gz"
  sha256 "f90e0f2d87f0d72d943653f02182c2bebcf29ce97d3ebb1755ae7188dec4da85"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5339b522bfb031216a6e1e3e94f456c369ab46c75965796a0ec238abe48882a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9180e6f04b46ace27109f8d5b0e1ea7a1081ee7f4a1cae311d6b0b97226d9821"
    sha256 cellar: :any_skip_relocation, monterey:       "bffde286e78f8098550d293df55c5b967f56f9d89fec29e306479e4e957d6bcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd6b0c27a56f94ae998c7492510284fce256264f989088bd2dc1f2541b5e711"
    sha256 cellar: :any_skip_relocation, catalina:       "52a01ccd8baafcde7ab80057288d4d21f18498b8f1d7710ceb89a80dc3886a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25eca86db2158ab195440d3e2d8e6729da2f5a0c6037c3a7da66c6b70df6da3f"
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
