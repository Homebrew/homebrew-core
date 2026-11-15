class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.64.3.tar.gz"
  sha256 "5aca2a32a9a69fa2a6d0abf7732f1ce394a93d239fbd0e3e82982b90f77d8f19"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe3a176d085346a62593ad3484a262b369650ead8d95330f47fce8022a23ff62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2227d4a6838aa466df744616831ea7099de683dd0c85f585323db53925f7f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8b075d88c654d4e27d979da348bbedccfc440f72d248ed074078073c18ac57d"
    sha256 cellar: :any,                 arm64_linux:       "b773477397c97d96e29faac77cc4b24b554d4d20d51c091d0e696990eb21ad19"
    sha256 cellar: :any,                 x86_64_linux:      "51548c148230a29539f5cb0bb01e4c0e5e012da0e0686e05ecf31f457e3b8fe6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

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
