class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.13.0.tar.gz"
  sha256 "54dbd60ef27cc93db6a13f93ab639d6e3581da0d478a109b59fd48d2280b5041"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7afde55dcfa9592219d4f75c1aa6289b5b8f79919290253c0d1ae0dae6e9f12"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bf75bff51dcfd67c9fefc8497e655f943a2943fa01bec056f7ef5fadb46ecf8"
    sha256 cellar: :any_skip_relocation, catalina:      "cac486128a7aacc852a30da4a180f11e0cc45e27ed0536c86db954bf265d9a00"
    sha256 cellar: :any_skip_relocation, mojave:        "65256fc4f360485ec6450b4117e6f9a497054afdb650cd986f78126ebb4e9411"
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
