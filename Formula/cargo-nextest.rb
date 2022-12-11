class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.47.tar.gz"
  sha256 "dbd685b0ef4e4e632ed0ee7136526a0daa1e73b11df5fd9b04a06ccd83557a1c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac2bfd1f86b578610146eeacfcfc426c1025e904e5353381e457fcce53aad33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ddc567c6eba16071493e8e172318e2d38d41d0d72c5e185522eff3316a834a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b44ddc6c10bebf080a8b9c1780eeffe25d6db97046dab3e8032acf8c5dec8d12"
    sha256 cellar: :any_skip_relocation, ventura:        "b2779143024d135218379805426ddca8b056a62937abb41f0ca50d0a665cf0fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e1424627265034b2482a0b08bd95d339e5a44dfd47b8117b38e3e278f212751f"
    sha256 cellar: :any_skip_relocation, big_sur:        "47a395cb2b8559dad0f5e371f0a1885ce9cdbc83c7f88356230a29d11b466897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21deb62bde291fbab8f1be2f62c09ccde4b3a0806eb572cb3d0bb416d493ce11"
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
