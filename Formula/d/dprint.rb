class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.50.2.tar.gz"
  sha256 "dfba0da97f394e4aa4f372e0013ffd1379215c7353cb56450bea0a2802150d54"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b776542191504aadb80e01febd82744fdfd5de0b93cf74ba4ac738370653b7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bba2a20c6b7165229852acd0fa1ca867563c273edb862f2f5f0596e6c80f1ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47710226f52c96c47759cf2f34b456113ef31a74b9af64e387bd986fdf476eeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b368266cef3eb8ffe2272a229c0f9b591db4a7adc92c9ebeee3bdc1cb168ce5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f0d07331cba2f93ef066d1a52ec001bde5a5047d19ea3332143a02e746f2139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5352f01226142ab83aab37094a05c02af7a2c6283d971bba2ebb219e5d1b6e0"
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
