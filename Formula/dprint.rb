class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.15.0.tar.gz"
  sha256 "2dac5b276d11fcaa02c16fab820127eec3f285029e9917f08fb39cc1dac2ca9a"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dd57dd02af568ca48a287f622fc474f5cd15f2a8874a393a6b61f85bc19cda04"
    sha256 cellar: :any_skip_relocation, big_sur:       "59346ff16bb9dcf61d54e7867b42584bca332272b406053adeef774939f97d36"
    sha256 cellar: :any_skip_relocation, catalina:      "1205dbf25dc7b843422dd60b6e9703c8c270ce2f08d6eb9237abb09ce9b46f7b"
    sha256 cellar: :any_skip_relocation, mojave:        "a7ccb9889224caf485fed45206ee754068f03ef9bc7bd78db1a6b0972a377be1"
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
