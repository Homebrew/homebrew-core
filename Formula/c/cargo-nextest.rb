class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.140.tar.gz"
  sha256 "707a39bea7b11e734b547eaed436d14b08827928e2de9c57370d0d667b1de3b4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaa52f8ee17818758bf6608cc98ae0d8061ccc2c5647fd4d2e2f2ad50bb883fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d719134c589c60cb658b96b3cb1b8663e8e92f21ac3e176a35fae3b4d31ecad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225ec7726e8c5b9258a911cf175f5277031c1d1193fa4eaa9edf58e9505b8927"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8fae04a48b98e9852af105202ee4ef9d37909593909b58bd76f32224ccfa7d0"
    sha256 cellar: :any,                 arm64_linux:   "a7679d41bc36af339520caeb5ad3c5d78005c5bd9f25814c77a25ef4507fba38"
    sha256 cellar: :any,                 x86_64_linux:  "c8e8d1f56fa26525811fb7e8fe343c7661532d44fc4a51f987a51112298d5f81"
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
