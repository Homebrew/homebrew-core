class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.97.tar.gz"
  sha256 "0dadd3cd0e2b7556a29a577059e10591e14e632724ae1d019651383f6a0c5881"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7a97241f04142f6bdf40301a1fd6e38b1226ef09c03d65587b07ca8b823062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a553d9ec91c1a6fcecc0dccd844383f3a780b76ee65e04ed43567ad2b013a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d22323de178f0667350e346be5ecfe6a28a0408a351f1387bc33cd1addb6506a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5085a3ccd055015479ef1581bcb34dd9fa01a26420a413951522aa5cd7d3577d"
    sha256 cellar: :any_skip_relocation, ventura:       "321f51d61c71cc5d5a9cbc0f75ef6b65d97ebb23eed9ed996dd7e52ced78a8e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e643fad7ea810f120c08acf161e2d1b01a178bfb789a3c3073c6d390cf2fa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d653430e5aca656aa66ac2376e2243c602e74bcec8541ded9b1c8b5be7df8fa6"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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
