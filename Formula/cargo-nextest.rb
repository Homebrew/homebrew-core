class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.48.tar.gz"
  sha256 "94a09f8270a17fd9e8e35f6da4e55efef368cf926b99cea4f50b0e969ff6785d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e343ac90fa9e9bba9c9aa18d88d10b1e3ee212dae690200225ff6cebef6e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be18c27367d4cba9551fcec728f170ce0683c750c44d5c6d0c47171335ff6278"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ecbf9036f866d31baeade796cd9e9accc2ecaae7a96207a2776ebc167622cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "b6ce1c3286aef9ca0d2349f7939f7260de2af74c9a0d17210cf1a5c3eacf7ced"
    sha256 cellar: :any_skip_relocation, monterey:       "695c950ed6fb64a4f4ebe269fd7936ad02b2ce74e4347afd28e83e3dc78345fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fcf028cb8849f8bf0445120a9c647bdeca56245a2a0dec3adf34b2931200c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3beddab0c6c5eec9e43522e6e3c9250b914d340806f8c3e5ce1e8a52ff73cf"
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
