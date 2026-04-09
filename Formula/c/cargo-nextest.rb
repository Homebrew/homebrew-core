class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.132.tar.gz"
  sha256 "5d51ce1d10b90551ed5c56d436cb57b1d671521a7c00f8df209e541f26d9735d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d383ccc9d1279b5bc383eb2f3734410e09739f13bd9f7207ade9a8593450b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804cbf4bcf1f8d79d8eabbbd18929535640a1f3b5d8d520c3a65fd40c605c21c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0767f70a000a528d16ac68a12ac01505fe38eeb5cbb588585722d12df7a2f47c"
    sha256 cellar: :any_skip_relocation, sonoma:        "46bc6a47a39244962f3f2137f195d5059d4bc9a2e743a6d4596eca9a1aa466df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dc4e040f4f94b54f95e01f5a2ba65a1b53bae320c2ad7d523ff740bda23010b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e05c13ee52ec8fcef66392527991860c593d93c4a9b36762a4e474c0d3eb7fd"
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
