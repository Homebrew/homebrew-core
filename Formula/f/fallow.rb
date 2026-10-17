class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.34.0.tar.gz"
  sha256 "5cf4d84edcb53ebd5d83ac3650a47caf94d345f6275abe2215bd027870fd7403"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "047deb97ea49a9b3819e5750d8a91a20a10d3b0b0c7f044fce96f4ac0c892f78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52bc60ffee54a613a715c2954d8c2b9090406b8f9253485750a196c2c0bf2e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60374fc1f5749ea751db033f8b1725cdb6221df3a628ff970392b09ae20b8f68"
    sha256 cellar: :any,                 arm64_linux:       "c37116e95d8369416d857025468c596653d60ef935c6d9c63447148893d616a7"
    sha256 cellar: :any,                 x86_64_linux:      "eabf11886a19980983c30e917a1a00313d520dfc547f2ec1eb52915e9ab18311"
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
