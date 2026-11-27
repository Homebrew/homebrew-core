class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.50.0.tar.gz"
  sha256 "71d3165df9baf4de51a35bf4e1a8bf813fc271084d0fe2615e7dc6b9bbdd03c1"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    manifest_sha256 "ca81263fa849e64b84c9fadbec5d42251ad0e1db6115f3e397687981148b0857"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb9960eae14e4f13a1211f4b03cd447d0e5b84ea76decf9a4e00f0a77613acda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9567e246c4414310629806de960586fb479dfabac9d47491c87ee8bdf27c227a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0789b3c25d44f57005228454af1bf5e3f1720a20e30052e08d04c085a2ba3f0f"
    sha256 cellar: :any,                 arm64_linux:       "86e9659dfb29040f6c0a203beaf828ef50242f1707e02a86488477051215c6e6"
    sha256 cellar: :any,                 x86_64_linux:      "c417ad4863ac4d46d59de3ecd62f49a4bba2bbb97482a4a2674c7a8a9711d67d"
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
