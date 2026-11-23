class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.47.0.tar.gz"
  sha256 "68971df04d371aa7004c86703b8750a7a8b98817205fd3ad8abe027bae71f1d7"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    manifest_sha256 "da3c81d523aa0b1cac79a16d33a6b12a0b20f1f90e1c1aa8b1624372e2621f83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1ce2ba2f32e8d818799bd07049801c84e5049bf9820e149f6ec4221720a34e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea31836a604b46424b9e3c83c71c1e3896aac1a0e2b78270010b9277767776d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07ea6319db02249ef8c516868444c00ecf82c1eaa19725b32ffac806843f6b7e"
    sha256 cellar: :any,                 arm64_linux:       "c746b74ec3450bf922f85b828a5197b0429d6d1cff1790b44ae667ef5edd639d"
    sha256 cellar: :any,                 x86_64_linux:      "570436a9e2c2ea9a10601060bc4c438095bd3004b1653c253b91a09401f5504c"
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
