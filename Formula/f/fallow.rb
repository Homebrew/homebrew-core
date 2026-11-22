class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.46.0.tar.gz"
  sha256 "f3db40eda9f415c9e3c9461bd08f00cb6de0f22c46e544da51af35f5e6a220b8"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    manifest_sha256 "d1acfd69e2c25f1f3004ec3299a98f3ffb6b2f35e63d99e819e3782a862092d8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5717eb24a5d49ccfdcba5317bc7798c3a9b7e66d6021a7c36ec282e03afdc98f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c979c698d709a01ef5ce5149f46286c39c40d591462495ef3c4ecd15d9180f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d31ada03a1fba9df8773ae42736a279488d03ff92e0b8023150c4fa12fbd0226"
    sha256 cellar: :any,                 arm64_linux:       "7bce05391d633b0b1acdcb49ae9237188a82fc7b97c7aeb6e3ecd6050492fafa"
    sha256 cellar: :any,                 x86_64_linux:      "2002b134b3759375ef937efadd17631c1848a926e9a29b217c7c26d1fcc12901"
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
