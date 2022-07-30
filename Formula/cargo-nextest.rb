class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.31.tar.gz"
  sha256 "2d14315ad233578611d024e09e0eb44bcdf4c5375701dfaea7e94df906ef5c84"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d285cdc92ec034d26adbb02b50a1ecf36c36199ddaf859522a8aa86c6e99dc74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "593a01277434df6a1ec635871c344d6731f24dc232ae7bbf34f61ce9261c1785"
    sha256 cellar: :any_skip_relocation, monterey:       "f323089b90137ab8e0bcf9aeccd2b28683b28d0a91f85dd89e4ccde873b312a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "08a9731fe4727c49bfd0824d1f0dc0ef820ba1bafb4755d8833ef199afc30c8b"
    sha256 cellar: :any_skip_relocation, catalina:       "b00f4472a5bb7467cfbfd015c3a892a39aaf69a7d5a6a1efebcc4897f3c61804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1314e4ec9ac8d5e89f2228756af6f84a0aaf514c5b15ec1dafe16fca36a6d230"
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
