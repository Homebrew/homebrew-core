class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.41.0.tar.gz"
  sha256 "b456f0d77224338d6002188237f3cd2b977837e2d993143a5bfabc6e4fbf3837"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b67fd3afe9ef749058722f5544841e76857db51acf96a790d97b9d0b1a58f3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e718bb1c72719c07302b4cb4d5ea186a34d0b5b8291c5e40abdbbfe12d778593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f045aad454241c05173940444d008215915aa91ebdd2dd371a16d9ccb1fa51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0820a996dc46629bf7e5c306d9c329d83c85273e242b889b9a3499e734cbea"
    sha256 cellar: :any_skip_relocation, sonoma:         "c95e136e7dd40d157faca12cbdfd291256ba4e2a111341a03bed196329ed46c5"
    sha256 cellar: :any_skip_relocation, ventura:        "d5ae402e85f0fe44dcb13283d11730d59525f98a2553ea89d5177be99f999be3"
    sha256 cellar: :any_skip_relocation, monterey:       "da9a6b73f45a988f6157359170a121a6dd0de323230682a30e5c5cee4855e6cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d67a54402b56f6251f9f1565ab810f301854dc5cad038382f5dc7bc727f8a017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2690fd1bab2945a46940573f4cdcabb0bb47256e8168dd76cddb92a4f93f7f4d"
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
