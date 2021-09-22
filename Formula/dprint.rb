class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.17.2.tar.gz"
  sha256 "e5ed8d899ba15f53c8870fcdaad2cff0e82b77077c3d1f770c8341d04ba6d423"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "baf1b6055ebf848b637d05bf3eb03ce8d58e055163cc0a29f9520a00335dde63"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ce5b34603026a40982f0d364abcbca02e72db69151e5bbbcc57053b5d54714a"
    sha256 cellar: :any_skip_relocation, catalina:      "2910dc20aec62d2b2f1cccd300d13276aa41b687991338af88a1ba9834a7fac6"
    sha256 cellar: :any_skip_relocation, mojave:        "3f448cdcca828a8763d85a8529522c5c6de294ad4fdf52a65f0cb10d7b82bc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99253986fa70909edcc1c50cca8c536503c047ae5faba2290a0cc0815288600c"
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
