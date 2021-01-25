class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.11.1.tar.gz"
  sha256 "3344ea1f035f38ab8b608e7ff69c6bfa64534cae200b810e4946e6d558c64aeb"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "390eda4604117de7d389484949424a130c3f417c2cbff2b5d59b06033eb7222c" => :big_sur
    sha256 "d87537fa6beaec8ba177aba620213b7504b689a6b6d2b0fe7a5b3c7c6861dae6" => :catalina
    sha256 "568b92a212191f284669aeab7ea1bed50c0beea6cd20860d0db0832d5dfb7913" => :mojave
  end

  depends_on "rust" => :build

  def install
    # replace `--path` arg with `./crates/dprint`
    args = std_cargo_args.map { |s| s == "." ? "./crates/dprint" : s }
    system "cargo", "install", *args
  end

  test do
    (testpath/".dprintrc.json").write <<~EOS
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
          "https://plugins.dprint.dev/typescript-0.34.0.wasm",
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
