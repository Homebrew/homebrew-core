class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.36.tar.gz"
  sha256 "455926622d67ff996b6e8dec9cd5a6f92cacbdb9fa899529d4d5aa3f6f985740"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ca07087fff18a65556d752b1cd10b50716bfea971a69edc826f8b4ee5d40bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eee7f3c81cb3fd9d5cfafdb1502a389f0d3ee74bb82fea7b8a57d1316098533"
    sha256 cellar: :any_skip_relocation, monterey:       "81a90a06200e3828a11747700a5e825cccadafa656afee2990e6789939a24488"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6a45c43593f0139956e240d38a2525ea47def5c8ff85622992e6986ca426d89"
    sha256 cellar: :any_skip_relocation, catalina:       "364c1fbd209dd8c2cbc18b0491048f79618ba5f7f4770e9c94d0f8cee6adf756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8333129ee734e705e89a2ab43401c51f6d4518bef5fd8b8a62758a17354d50"
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
