class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.122.tar.gz"
  sha256 "08c47e72e1e2e1f91ecc649c2b8d46ad5308f58ea674afed163be7c210c3aae9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910e12cdca3a5d790b758eeb790ae48f58c63de95fca6d2c670352e0b3fa05f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef048d06c16cbf9fd0c1922df61e87a3146f399e3543c82580d8f5a0917fa1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182e2ce40e25350479ae03aedbe86319e8ed3c3542514ce4160ae5b68c73d67f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e01ab6cecef7300740ff91be758ef43bb25484fc61df707ba06a17fddd964606"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41dd860b095c4fee35b0dd9a0b1e19eee984f080788bab9bb68ae644027664f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284bf58104f2bba0b585afe95bd6c059622f64bc33fad40fa09f9b9070cac297"
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
