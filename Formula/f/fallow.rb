class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.43.2.tar.gz"
  sha256 "771644aa95d7df0ea6deef3e55c0610205d30190af58e976c64ed881e823d49a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fa64a35485817588ab865919c1f5a001642e0c83799e29405cab297524d8bac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f78be6fa57e947e65035b91d59d175ce3409e8a747070b8bc651f1a418725ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79548bfc5da06c256eae43cf3110637745ce8de356b4f43cbe1bd1ed0e6dae39"
    sha256 cellar: :any,                 arm64_linux:       "054166afefd155a8ecebefd2b0fd1d45eec2fd499c33f652bd4d3d8482a90142"
    sha256 cellar: :any,                 x86_64_linux:      "df6ca00624b26d3b948002bb770e59cf03999e2a0cece3d4d723c1fe678c6619"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "tools/similar-code-sidecar/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    system "cargo", "install", *std_cargo_args(path: "tools/similar-code-sidecar")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")

    status = JSON.parse(shell_output("#{bin}/fallow similar-code status --format json"))
    assert_equal version.to_s, status.fetch("companion_version")
  end
end
