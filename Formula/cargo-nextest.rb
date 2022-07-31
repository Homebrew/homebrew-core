class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.33.tar.gz"
  sha256 "f75c53b4df3c72ae5a89e75c15d571645ee6719d86bb1171d64d0281eb71361f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc0690ebc2bdc8f30858cb14a614dc6de2b2cee347d12b708ba0435f14a89ced"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bf196ea77069a2abac96f8d221612cd9bb27423bc74bb2260af5abf81ab5cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "b0819cca3e65fbe285e7307ace5337fa691fc993ecc58575c61154cb84d662de"
    sha256 cellar: :any_skip_relocation, big_sur:        "5358fd3e6b0e4bc94b02d61d9c46ed7e85a13eba92cf86eaff496a017a59d0fa"
    sha256 cellar: :any_skip_relocation, catalina:       "91757833850de3bb3ebe04a0397c397908ee1a25e86c5d98bb340ac50abbdb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00b87b7cada0b3502f02f8280c749fa1897d02eee3ffdd57633e49e09162b1b"
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
