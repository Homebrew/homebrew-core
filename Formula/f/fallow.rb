class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.34.1.tar.gz"
  sha256 "226b9c0b3a9cde9ccf7fd6b7b99b7dfac4bd1081ec2f19694879a9b637158153"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "decd0d64747197be4a301cba5b81cc3cc464b65b78c0c12dc66ea5c15166a3a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f56bf8a8c38a31ad1b41d4044baab20d896984497961474f7d8dc01dc02484f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c653f6d3b3c52d240ef86b8ee35fa601f029297902a5ee606ffdc374ed6052b"
    sha256 cellar: :any,                 arm64_linux:       "e8cccefb1d7e43195521cd23d489213081908e5e8b1894d264ce65c9aac1cc97"
    sha256 cellar: :any,                 x86_64_linux:      "24ba7a01866a7f653c059f29a52ae630671ee6cbf59c2b99fdef09f0a75ce13a"
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
