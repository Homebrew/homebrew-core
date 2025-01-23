class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.88.tar.gz"
  sha256 "77a6029a409f8ab37e5c8bfc31fccc13bc5ea8475ff3309947a5811fdc758ef4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf87a68bfa48852b4dc8e8b162253d3aff55a755b1e6f25a793844dca579bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2959ba88a80a23330c42720d31eb5e582df32e191a9899834b629a9958d52d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10c79f06c0d10f60dbcd9d95c3166735b0b5467b05eb7353d9b66f0e36c092d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33deb754b798325ff50af6cf8cf486d42c63af724ee29ef3bb24f37828a8f9d"
    sha256 cellar: :any_skip_relocation, ventura:       "efcc8a61280ff5c0741c3c116580ee987f1a78bb43035627ae894e7d12cef6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13184b4fa92e1aa6015c563b219fef37438a689f6c01da8998ded2f517e2a1d"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
