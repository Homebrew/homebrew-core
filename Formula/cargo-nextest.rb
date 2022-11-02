class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.41.tar.gz"
  sha256 "cbaee0266bd032879ed29ef92bf5f30e2b39d8d2f477139c11e7509cee858cf8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8444977cccb88771656a51f1e125e77dd35fa64b636ea38beb1f7aa5c608ffaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c9826cd48d5904071d076ef910002530073269a95702aa43c319120cac8b945"
    sha256 cellar: :any_skip_relocation, monterey:       "7bbb54b972830ef241ccccbddff659026ff57625614623f86d901b9cf5f79a66"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d4629fdd5646180b118d44eb275272322a8f9e08f094876dc28a7b0a3358d87"
    sha256 cellar: :any_skip_relocation, catalina:       "9ef13f6f525527f25dbf425cdb770888f45c62cf34634b7efcf9294d6f64379c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d035c708256d38f68eb16326bbb0b52cda8fa5db97c730c80889b354e523fa"
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
