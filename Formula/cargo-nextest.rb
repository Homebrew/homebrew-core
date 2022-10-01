class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.37.tar.gz"
  sha256 "3f50929b8fe098cf2ed8e2b0993983aac28a5eaf52e480ab5cba5939b0e38ab1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "768afc644fd29081629f75408eb163a9c4f72d24170a2f0a492f6f400f7c0071"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f222ec8ced73ceee44828a1431fe424aed5b95dd170ea65107070d6e9bbdd00"
    sha256 cellar: :any_skip_relocation, monterey:       "cf34cdbc392daa55968e85f5beee1edbd17a7173873054f8356589e307752c73"
    sha256 cellar: :any_skip_relocation, big_sur:        "88c0df192b54bb36815237542c2edede0a196ba2038ea2a821149416245341e3"
    sha256 cellar: :any_skip_relocation, catalina:       "0440e179bf18294720ece7d8edd4dc5ad005491ef25378bb19daff4dc7610a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79920be1b8ca0e502cb3495eeea221b81ee9f4c0fef4f3d958547638da48471"
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
