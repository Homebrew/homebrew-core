class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.66.tar.gz"
  sha256 "2525fa66c6945821fc5b957b5cc41922c6879731bca8711f577f8794ef0b389d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c1ab33c6eedf11245e10215b25fda4001e81dad5c7bb4837ee7b9bb69598daa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c44558358f4519c6d852583f8d1f0f26fb391e8cd7fb5da1b8a796a29032ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "284605dfa888e110417b68a51f92400045779d451c0c579e8286e343c014eb96"
    sha256 cellar: :any_skip_relocation, sonoma:         "89bd3fdd77000040ac8d2cafde7cbfe839a60987800e61eb98416b0f380d45fa"
    sha256 cellar: :any_skip_relocation, ventura:        "aa526331ff89012cb87bcdce0f5c00412f76cb4e07d4a75d80292282e61dd243"
    sha256 cellar: :any_skip_relocation, monterey:       "c7adddbd0a100329f1b7a4fda5accc4dbb4fc80a778af15ed198ffa9dc1a65f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f210df3fa08bccde98b4bc5e9667dac7c63ccdc46d748fb5df2eb9b8a9a6916"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
