class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.133.tar.gz"
  sha256 "7854bfc381ca2d5b1e28f7328e784e81611c599ea1c18d38aebf68c380b6eba7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131a906e28d40532140903960c8cc8a21b21264a122e3e648cde1ca7a21ce0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc22622f390e07e66085c4e60ca5e8fbfe49285699420b183b701a1a9baf6adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a8d47edbd7e0eb89e8d58760c759a7acef2613541540b9d50efb156e8ef374"
    sha256 cellar: :any_skip_relocation, sonoma:        "038737c8e81de929d4ef216379b909d77c6a9404d50712883e240d3d4b4cc0dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80927d1d943ec7442fc2b1b69dad41876e18be98a8cd1c26db80aaa75cad7fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7faed86a441353155a58965779fffa323803fa3f70f68c3c4558960d101f137d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
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
