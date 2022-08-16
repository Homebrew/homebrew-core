class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.34.tar.gz"
  sha256 "ab86ba322627d1a895b7ef5ca91bb4fd77f49c72007931d78457894ced0d078b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfd1c7809b1b3cc25a27631e0fd18782b46660dc307e2d9319e040debb0484c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6964d9cd8febff511873b2b1c9515209424422003bf03754cde304fe6a6213e2"
    sha256 cellar: :any_skip_relocation, monterey:       "b17e923f06280e2e62271ccababa36c4d2a1eea973a71b74c7f58f5b946b18a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae8b01b3dde671f93a72b25d44fd7c28aff6b59eef4caca8b472085ff21258aa"
    sha256 cellar: :any_skip_relocation, catalina:       "7a1a99fdcafd9b0382c644c44abc9081143177478921a2ca63f029d0b8280fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e0f50f61d62b3372ec5ccda69caa267c478718b1c09a806e4c5b448c58e4ea"
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
