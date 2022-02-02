class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.22.0.tar.gz"
  sha256 "eef5b93fea6097a0e07aeab3e7529ef3b5072ef16e8843c7ab87404a39fe7a23"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "140c8eac1c2b5af3bd4a7d5fa3b188d1d20c80401654da427e3bcbbc021dd8ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d87397e5325f19eef097307600fa489b13798c19f7a3327fc361c389ab9b788b"
    sha256 cellar: :any_skip_relocation, monterey:       "8457c8e34bd2c34a39638fc57d3739b82a76df32e4895b130a055df0151a3308"
    sha256 cellar: :any_skip_relocation, big_sur:        "3509d9d2863c5a63ba82626d548d8fe3a58dda04246cacf2a44694bbf3326333"
    sha256 cellar: :any_skip_relocation, catalina:       "bc2911ea3944b40e24edb1ad1d63b4cf4644dcc56e22b7bf6e6692b3d7cc4e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d6a7f38571848ae21d9b57be172bc443330a65f1e36055edebfb4dca4fa57d"
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
