class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.57.1.tar.gz"
  sha256 "b890dcc7450ac8e0b8f5ffa6064b7f9b136e114148ab67077113bf28e1be37a5"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a41b7de85773dc874a35afc92beba891da7752c16b7d0c22613cc2633248d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a44a5f313721c870021bb7b411b1ebcfe8c8dabda217546262491b6d3100d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc1a210aca626b11869a2ef64c73a47c37e2fc4669da063f81378141400d01a"
    sha256 cellar: :any,                 arm64_linux:   "df571e7aa546dadcf0d54fb88ccceafc98157fc5c786955ee6bdee2bd56b21ea"
    sha256 cellar: :any,                 x86_64_linux:  "25dc0f7d215c0122fae692f8d9a2e02092ec9ea18af2bd691f25892a44c6f26b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

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
