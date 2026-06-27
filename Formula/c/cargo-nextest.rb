class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.138.tar.gz"
  sha256 "b8f98643d8831596e782bed7163812cbc1df0e44f98272a821d3ebe8ac918714"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dafa40b820abb8f0905a325aedcbf818a5e9814eddb23e65fff3be5e3a6cc42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6615108fc25c41034cdb7e2ea451cd6a1e9dcedcfaac9b24028ea17767a4754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e0585201227741aa4454086a23369b77518dda740e7be4ad534f20d10e79d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "619595c1b6ee06c97536beeb1e8fdaf9064cc487e0f33fdcf52a290602d4cdf7"
    sha256 cellar: :any,                 arm64_linux:   "7947564115f532f186d27bc4644285c265921b3e576a5990d0b8ca463a820d36"
    sha256 cellar: :any,                 x86_64_linux:  "98cce00cdffe15b15fd5651e49e160f733c453b7d72638e4923313443a4f83b6"
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
