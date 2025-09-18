class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.104.tar.gz"
  sha256 "e0453282d86c11c7a410d999bb952f01df27ea433e0c1cb6bbd87c51946dd31f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2132dd87e17a6e669c6c05d98c363f7084a382c4a6b6a8c8ade98a5fd20a3ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a54dbfc1428f41b0191e6bffe288f375fd3f6dadd12afd40223ff5aea7cb6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b8ff530a6525278a12b9088aa9fe4d9fdafc075d21f3a3814da35080624e12"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0f45c23a3f37136443ba90193651abb0d26897eb6013560e8870b0281e0a7fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d3d7e0a20769d52b956a1ea792df2634636daca42cc9d3e3ea2462bedc550f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba9df6ce302993cb75b400cc61a32f4093e971e82f10b2dd31a9ac5a6f66c28"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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
