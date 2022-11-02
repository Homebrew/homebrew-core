class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.42.tar.gz"
  sha256 "0c7a353b12f40069b423543ef45bd6197e85be5d22dfcd29f6a6faa1b7c6c13f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "534adb64b30773a722eb738da3c1490ed34c7c7c054d2fda4d9d19139e90a196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eea48e19f48d1f3a48ad710df26466eed0f68369c438dd465cb5a1aeccaad44"
    sha256 cellar: :any_skip_relocation, monterey:       "3257b38ac850bc45190c212c8782ccd8011c5a71e366fb13f1ec996b362b32fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2924636bfeda9618fe8055ebef66249f50e96fe5813a38d9b47a5449925b6d7"
    sha256 cellar: :any_skip_relocation, catalina:       "7cf24d691cbb16a9e9151aecab6a73ed0de8cbf0b698e549967db0184d6d9547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782fdd581c34d9465dbd7260a8026b947a7d711de9f38d208bbc35bbfb73a341"
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
