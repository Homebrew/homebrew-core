class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.29.1.tar.gz"
  sha256 "37fa3e86090a6361933f5f3bfb067158c177a7025a17d4615a0e4212123456a2"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2afa62966b754ef9debce6d627542aac54d92f6c489eb51b597bdfb00e30e0dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24bd819c0b91c765be4e10b7659813c37a51c0b623a5dac39b4f86797819b1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f2058281c9186ac07368b027204a67e79091fb19ee4627c7c14329a68c21720b"
    sha256 cellar: :any_skip_relocation, big_sur:        "956b43e8d93598b570969778dd28b5e929a31cde1180abccaf031dc9e94cd9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "8d52758a445608a057cc6e5148b249fff6187fc78ad444342f932089527f700c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6758417e7b339a410fa4123ad75c6d87b99fe5c18e9ee908b79c46fc7457ce1a"
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
