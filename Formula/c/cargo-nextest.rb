class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.145.tar.gz"
  sha256 "6ba31b7dace0cfa57a7f9f534a82732d037481e161e076bd713c3edf1fdf6a63"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0d3a038006737bc52bda122de331418342cac500dee7978f399e4573b8f730c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3487529536651b035167decd86d103110891a88f8c1d14e1a9adc3c0c48473e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1668cf837fcc1372697d231be5bedef9998c15f31431fb838f76c167ed923c1b"
    sha256 cellar: :any,                 arm64_linux:       "3149db6d3259f422ac73aa6751a3d68d8aa11d73f5bd11252b11d2b15192b123"
    sha256 cellar: :any,                 x86_64_linux:      "448172e8695c28373a7ef653acaf7ebeee9c77b29cceb22a7c9f7057f5db46b0"
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
