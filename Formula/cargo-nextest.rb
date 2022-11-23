class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.44.tar.gz"
  sha256 "e017a5d5a10d08e654d9fa4d8aaac7bc858c0d71f468bb50067b44336fa845ab"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78381aec75b059ab5800c53720aece31865fe436208ad902fe8b2f5f98108b07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0454dd904b7c6f5368293fa7362460fa39f4f88a67a237c4ece4a35a9a5ae2ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96cb18a97bb38635a68a52c91d8d2ae383eeb0c383f415c9a9df4a6c706175da"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0580f4ce52b094a2865d35f542729ba2e37ce3d414818749617aa4c92ace72"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bea9c842258e050aae9be88e4c95c1635419ad5d44f303e7b406f54bcccbb5a"
    sha256 cellar: :any_skip_relocation, catalina:       "155f1fddbb43d1160658e682fc950537b31c033812fd2b49450dcf1904fb381c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcc2f406d7b9af1f96ad521bcda0166939b95a85217c8cd3c35b9e280a1daf1"
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
