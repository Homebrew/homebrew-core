class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.2.tar.gz"
  sha256 "9dde1ad8967071685b84b3a7f347e07ffd6e8f524ed1e466fe1d115fca66f32c"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9969c375726f13cbfe5a03517d372db0eb60bfaac3bc84f2e9a8272816ee53d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5164796227ddb2623a6d44416318c933b1fd2a2ca3d0a41be01834186a1051"
    sha256 cellar: :any_skip_relocation, monterey:       "7590464028d7299fb36af49646509c35aecf880897c3d28180988a5bd8d49ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "694f22ff07d30d0f0d0bc9fa21d05d90ba7cc02da86efb77d5c9ee56632c7e16"
    sha256 cellar: :any_skip_relocation, catalina:       "f7d1f0e964c468eb5250da63d173ccebfdd6961f2d27e6015a02b7e25d055f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2356268fe3e9c30eb82fd0d725787edfe625cbb64cccf168b597a0801291fb"
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
