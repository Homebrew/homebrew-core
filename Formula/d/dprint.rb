class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.49.0.tar.gz"
  sha256 "e97c1cf1a67decdea7c79174fab33cae3b6a95e480e51d8cafa6a827becbef59"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4946ccf00f43d736cd67257e52b0babcbefeb7979fa4a342004438010f06df33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "394f37f3d96c5de24838bce8e3833b62f3665b9db34fb8cb6881fa5151db8c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6026f7af2c0ef125a328b02ca1816fe6e7af33d13f70ce75aa41abc681ec258"
    sha256 cellar: :any_skip_relocation, sonoma:        "f63b66d10e587b123847c6d73f4d9c11bc99cec8881a673016a126e8417aedf3"
    sha256 cellar: :any_skip_relocation, ventura:       "657a366bbc1cb683ccb2bd8c578cd99c293dd1f691a4a65787ec7c31d8fd1eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9c5c4d58fa8f53799b17014ab56a44ff8408f62dc897316f309420e452765c"
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
