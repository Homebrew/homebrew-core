class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.15.0.tar.gz"
  sha256 "2dac5b276d11fcaa02c16fab820127eec3f285029e9917f08fb39cc1dac2ca9a"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d4cc3fd88ae59c2b965e3fed8a7313a3d0de350172fbb0e13af517c0f2582d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef7c046d03912ece2ea33bab7ba26db5531d2b0ed22ae0274f2722b4ed06231d"
    sha256 cellar: :any_skip_relocation, catalina:      "9a9c3ce28c4192c7656412e00525214e67bd3cb763b3fadf374abd1ebd79602a"
    sha256 cellar: :any_skip_relocation, mojave:        "3bf6876fd10bf5a1c5d149dafaff8b5646bcfb2fec8ed9c7da0eb6125b7474ea"
  end

  depends_on "rust" => :build

  def install
    # replace `--path` arg with `./crates/dprint`
    args = std_cargo_args.map { |s| s == "." ? "./crates/dprint" : s }
    system "cargo", "install", *args
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
