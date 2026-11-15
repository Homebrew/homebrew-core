class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "54be64e0439b3e49a37d0423dd04864c720db9b37ad98d57c6d1569bb817088c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "79db7adb9b9f2e2f82d44e2e4cb09c40c769a69a9af1c3e7380692f54575333e"
    sha256 cellar: :any, arm64_tahoe:       "cd29b16b05a30a7b6a892cb6c61c3d9532d3a5e84eabf8888afcbefe9c1d687a"
    sha256 cellar: :any, arm64_sequoia:     "1d62781aec700d7d31a55689f7274f0c994e2f1b606e3f52daa802574a93e55e"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-instruments instruments --template sys 2>&1", 1)
    assert_match "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory", output
  end
end
