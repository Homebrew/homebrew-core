class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.114.tar.gz"
  sha256 "aea4880573c0fec578179a479c77a66559164d4edc2c73248385570498ef6350"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c442fdd1d5dbe01c4f8271551d6e9cc191686cb4640659efdc1add418ddd485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0d18befeaed9e5761a2f8d061e86f4e9b451310322bc85842007c9c4630509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f292ff8ca6019583bf60296471dfb80bacd3fdcd72d87d279e14e22606417b"
    sha256 cellar: :any_skip_relocation, sonoma:        "43e299775fd0d470a8a431984c14076b6c505f1c4a2f8f6359f94f615804d15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d590fe99fa0ac97d113dd10e946f6fd5e92112b41327edddd22070221e6b30bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7946fb963c1648c45635322101990788d66997d14fc86ee7eba96b23a57e34d7"
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
