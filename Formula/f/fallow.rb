class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.39.0.tar.gz"
  sha256 "ac9f3d853b06c1d9098861a22117b9e90b6abb823ff59a93ccbb612f56ea0b19"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6cee4c2f352cb7cf10daac9f88b7366fefcbd26460709a8aaca3d1bb766e57e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad84c9d12fa434b6c3d42122c30cd360557d2200848a72efdfe20e1d8ea7a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db4b85725b8bf950da8473eee5cb1958d1d43d74d3fc9562f4945070d0e54d9a"
    sha256 cellar: :any,                 arm64_linux:       "28050cabb162b70166c3943c98f798880deaaff4a3504a5f7c88f4cd257ace48"
    sha256 cellar: :any,                 x86_64_linux:      "6086d5b131fd3656a86c1fe18a77a0953d155480014bb917b0a7644faa046f41"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
  end
end
