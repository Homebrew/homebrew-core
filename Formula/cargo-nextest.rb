class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.40.tar.gz"
  sha256 "db26c0a68f96d0c8f53eda9efe9543a0633ac5104d38777b9152387d08240b65"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636cba918649f1168b675cdf6cc8e60a9c2f1a67d8c6523c2523885305d5931a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603e2012e16189dcf02aa3192835f5f22dd33626224069c8aae873b1637736ce"
    sha256 cellar: :any_skip_relocation, monterey:       "8db5412b6d2ab9de9ad65f3bf2d59a322c48482378a0dd79615b1970a64d1e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8e91d7e6e58256b71fb022a839a38395fdbf003f623f6439a6b57c0b68e8eb5"
    sha256 cellar: :any_skip_relocation, catalina:       "ffee1ab79b08a8829d026bdec36af2cb58247e134155bf9e6b817889cea89719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899bc6a8495fbba22c12fc13d1280d7d2767d5b9ae7f7f313caa5e412e1d83c5"
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
