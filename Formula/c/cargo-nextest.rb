class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.105.tar.gz"
  sha256 "4b939499e51d366f88333e628aba46c7722ad23eeedfc87a04fab5582be6dc07"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5a6871ea1f2643ab9837a6d6ad18cf5e0e2824e84083b54ffedaccc3ef9254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d409ffedbb50bf51de5e53a277fafb5e74376dc7454187cedb2f45a75ddddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5300ddf334d25cf09098aee335e525e4ea67fadb49ce1585d6cec99c33583e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb265653e155cd7a59962bac188cbade7fac6e44eb167baad3abeb13f2ad7193"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e33a8d4ade879c819a293062d7e2c86400aaa3561c254c70a4624e3c8b9aad22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7195652768fe8d67b409b468f44c6ad9fef827bed737b51664b7ac6211ac9407"
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
