class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.137.tar.gz"
  sha256 "9d9ec823b8183259c62ec0db924f0222d7fa76a9d99c73a1cd2dc02e02bfc12b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b5cc9f1d45112242b95701914de68878742ace332f3cedf17fc921ac0e80dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a13982e58a7f964dc5fe7e4f3f7ec9a2b710ef6c799cf239d857442661c57e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34dd9d4844030bc7918451b175aea6311ce8d113de752cc9e1e6982421bdcc2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "31abb34ea4eb281b866307dcc3e34cc400a90a42368b81abed6899493aa9520d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9bc3fb853499254da63a09d18eebd111b87a76985386e57659c353a2838123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8229811c1c0bdca03801742c50447c20b335b4f3a8ce1d7251d7f59a6bf32ef"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
