class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.143.tar.gz"
  sha256 "4ad5dbe9e266fd7303c39413c5610c4ca03f3c1b70f8d59c81266a4452e59361"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "453a47f752c2b2d28711f5ae88a59dac93b75c451f23e2f1816608b60e011fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded3e40f343b57f4089c2145c7f6fe912c5efb85c8e0f1372ed7d3ca15d44070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79999882a20402ec90b58dac26ad01bdf8409a8255006ff125fd13b5a59c342"
    sha256 cellar: :any_skip_relocation, sonoma:        "b165d6411c93027890d10ddcfd42b31ea063fb86896d37fff536ce22077a69d4"
    sha256 cellar: :any,                 arm64_linux:   "7c73d794d932b6bb039d671decc0b56945ae54ef692a85f44693ad9f0e88a711"
    sha256 cellar: :any,                 x86_64_linux:  "6e362427a1793d8d58816c7ae76afb7baf0d7e93c8f1503d87afef5d034fa3e0"
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
