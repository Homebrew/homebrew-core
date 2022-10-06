class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.38.tar.gz"
  sha256 "2a57298eb484dd153e50e46f8c8961efaed23f489fdca522d462a1dd0ee6324f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93aa920c9c46d5187a24ee1234635dc1ee1e12232c3312250dfc59396a721e52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62da3e8ab49dd294408289828f12172bc6c03ee7f4a728a6224280d74ce802d4"
    sha256 cellar: :any_skip_relocation, monterey:       "a809e2bbb507385c3134633b7a10198ab878fb5820ce5ff6a84f0fa061f099b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc584c01334876e12481d1e5f5fa26c9b9c55fe48cc84533b7151101dc675aa"
    sha256 cellar: :any_skip_relocation, catalina:       "546e3c6a7b02448352bb842e29567f5bf828a84f918c71f1ff8d34add775b4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37075df415d33256e0a0f6ce73c93597ff635b6691eee7a10aa623c773e28fd1"
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
