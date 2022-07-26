class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.30.tar.gz"
  sha256 "2cc42582acd9e802e75ada00d065fe6d2ccc94ee5dcd4bb970c6336493b7b2e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e2517296312678eae064e7877f757518b3b8511bc9e224ec6397c99eab49f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abbb35ef588be0c7ebdeb375760e414d93a2281f45cf95a46fa22568eadeaba9"
    sha256 cellar: :any_skip_relocation, monterey:       "ad8d7937107d60d8cada4fe9bea5c7fec74e3c45f66ad22517aa15818d7ee175"
    sha256 cellar: :any_skip_relocation, big_sur:        "75aa0ca2bbd668f2bda0c353ae36cf6ccf3bd4fd8378d7c8a0192628378619fb"
    sha256 cellar: :any_skip_relocation, catalina:       "ffc5e4ec26135f3d96f1648bd29b2fca0b027e49f843b0ef25ec1daa5b3133a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4fa36a223462195720ae721d455ffee51fa2a3ba4f7999f96d35f2f0b54e484"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    # Fix a performance regression. This can be removed once Rust 1.64 is stable.
    # See https://github.com/nextest-rs/nextest/releases/tag/cargo-nextest-0.9.30
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["RUSTFLAGS"] = "--cfg process_group --cfg process_group_bootstrap_hack"
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end
