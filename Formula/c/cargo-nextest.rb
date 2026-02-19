class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.127.tar.gz"
  sha256 "d45e04df901aaa29a7feab9efac708ad0b9b7ef1845bcfbde8c54b0c8f969b4e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b5d1ed8a501996d16a810c31610137507d9a38af4bd516d8a211e2efc842b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314f32ca5d7a3590dadec10d0b869602349a480060d8cc3a9f08d970fc21c46b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f32044095757095293067b9844ca5835d6f68befa523fecbe202cfc87cca72"
    sha256 cellar: :any_skip_relocation, sonoma:        "d558e44f8a8cdcf17224e43eef6eb1e7feca5ff5f5e94072e2a6c644c2aabe2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8369384f37022c2550141d26148130d8d534239c121fc7b8bb9427d459fb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86da820b1306480d6fb987c8d004f1802f39db7c21fc20cc7b3a9dad93f21e5c"
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
