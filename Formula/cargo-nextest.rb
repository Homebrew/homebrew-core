class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.50.tar.gz"
  sha256 "a86befb4129bddd1aea9da6b148c6d4cee92926850f2a09776e327448745d2cd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da599bccc0461a803f8139993336f44d2b09eef44d9f4a6cee5e760ab3893a34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58844af0ee0f02cd3570a6d43f2028b5b15b6f72daa447d2c69e2b8b1884209d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5db89768d362b28ffa9ff491b3dea12a1c953edf917a896b4163256d2c5b0af6"
    sha256 cellar: :any_skip_relocation, ventura:        "129ed9eada14ad0a3c19e6d90a0f7c0382ab37fe5588aab0e0ed2c18ba60ac35"
    sha256 cellar: :any_skip_relocation, monterey:       "1126d52020f3a932fbba9edd323a1fdc92a2a0b71e64fb0d65bf6a021e86ee45"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e45f2edefbc5b1d2dc5ebc0d5897de609ccf9a9b73376e4658d04d674312ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0ab2cadac5b3fff482d6c24ddd0b572c676072e2d8f63fde98946c54691485"
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
