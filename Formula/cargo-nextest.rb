class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.45.tar.gz"
  sha256 "bbd95f22ff249be9818be3aade67ba65d33c0b91d5a62935141cbcf2e02d0d16"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfceafe46aba1e8933cff8ec71765f358c1089aaa87d4c73042e8fad10d78741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b93b108dfcb59be70d9fa00febb0d47d23ba18d0609ab9b4ec13ac96b23c30c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb7516c9259173c36a6360bcaeeb8d427e38417de2940f722f5921094d31e014"
    sha256 cellar: :any_skip_relocation, ventura:        "006bb8fdaeb158374efbd842cbb638dde9c93353aa9f8b2bc2b0466f1cc29e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "58f2d0e2e21000b04b53c91d4d332cd52df1826cbfe5b16711dbb0b0df268ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "959203328cdb41dd71692cefd5ce877395a306bb8ee207355cec502999b5e0b2"
    sha256 cellar: :any_skip_relocation, catalina:       "7d60ee9baeedf633ff77ccc8d8e4de6e0280e719d0f950e68b5e9342de0f7d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172f63a1754029c44aa11025c5cc710ae477c48803f45ff076d23048973f4f9c"
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
