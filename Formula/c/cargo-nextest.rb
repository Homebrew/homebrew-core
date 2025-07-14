class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.101.tar.gz"
  sha256 "ab1eca47940231c99069736f765c75330440a14627c11e74ab98c3ef81feefc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f867fba5f6f02f8876e56cd98994b8e6227210c1138f46fb3a34864ab65e944b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdac8907fda29040870cc6fe775913fb0dd3317bb58a0a0338e4c9e165373f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ab45ba02169382c4461eb078f002ece79e2c5215eb7147bdbbc856047a7aed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d0d867479e3e6e2d5250fc3909cdae959a882a385114434ab61ddafff2d020"
    sha256 cellar: :any_skip_relocation, ventura:       "e67c0ceb9c981d397587c8fd6fcdceb7ce2d60b7a44aa6389f82230d19b02616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac868afe419d1ff10d449f51bbb14fc8c21ba1dc1253f5362c7301704d05320d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaba46475877e79616ff775d0a00e5a08bf385b9f0dc3727f44caf1dbda7736f"
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
