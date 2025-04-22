class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.49.1.tar.gz"
  sha256 "df019b295ff137ccaec3ad8c7a39282b485b6381ff5a3519ec18bd3d7c89ba72"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b0e4b377e98ad778793484a3dff59f74b29906ccde4b94f52acafb9917195a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a11ad7af71def0ba4b5a24c8aabc87563cbe745aa4b9899308e22ecbdbf844"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b317e6c03f9dbfb204b69c5600b46a480969b4754939d6790ba84ef504a5f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c79faf66dab060c0f8a12748640b27b4749751c52e61ec066120cc8e49e48b"
    sha256 cellar: :any_skip_relocation, ventura:       "888304a28f1df47eb8dc5acbfe7c7ab7ea3ed82bf2dc01b8fa6e4cad48b3d526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcd8dba5722c9dd55148118451136d91948d2d641058a7b923e2b9436af151c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7408ff0f353f0797570b56ba614081abe5fbc553f97d11c4ef7b2f0b175c581c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")

    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
