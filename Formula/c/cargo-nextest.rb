class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.94.tar.gz"
  sha256 "496c2e14c0eb3f2ee6069f86edfacd4b59817e78ffefef7f3f25cd3f272bda91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b8d28b873028421e5e5a6dc96448085124ee62fc319770d0e9c6a059ab0444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64589b2fa7578e8cb73b74c59154d2080a7374ceff06e6e0ad8c89a3265951a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25a8d6a50370cdbcd89152fcb2d1116c8250f6f123d6051e01dbce1bbccb37e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1746e26195e553365e49736c6b4cb8b81fb193a89f4191afcc49d8fac6365e4"
    sha256 cellar: :any_skip_relocation, ventura:       "91b5d4aadffed318531b11283bf1b592a1c50756b27b5f17574f7fa61d03df9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d07fdce58eb71333969f0c449a70dbc94ae447cfdb6118685507148fd452f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83411a8a09764dc1bb6c38f65f4846b48fe66e9a10c8ceea331005016076663e"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
