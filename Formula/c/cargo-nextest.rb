class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.151.tar.gz"
  sha256 "613c8855e6a5b9f9d12920bf74a0c191af3f8b5f86ff4cf27446f0f7adfc44ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8abead7e90a53fdb55dec111ee1377db8a1909fc6ecb5bb4048e7b7565181e47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef2c8545d322de17f8192017c5b4c9ee4fe756b65011a81b2c9c0e27a8fa6030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6bdb0df4a16df2b05732b4c2611d756af5ea57adca234dca2af4c573c8a7b460"
    sha256 cellar: :any,                 arm64_linux:       "046770197b988e98d924d5a906eba54854d13e0506549a1d107c22511fa5764c"
    sha256 cellar: :any,                 x86_64_linux:      "27582b54114b885a8f0c424197a46a8f011bbb19fbd553c1e2e3cc3d1f358b8e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # Test downloads a beta Rust toolchain via rustup
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
