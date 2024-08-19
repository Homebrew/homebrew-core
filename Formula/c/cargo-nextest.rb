class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.74.tar.gz"
  sha256 "93ef379eac82d849fa7e46128c579d006a0ddb397d0caf94d324ec90b1b4f906"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56db1acede667165ef428196eb1bf5dffa291171ed0ea7c7debd96c44429b6f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fb4802867f0629f60ee7ce774ca1b8c9b88520fe9e323c51aa4bf413078e4a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aade15fe3fb827263c2e6b4901d21d317a69f537c3ff68dce614dd375e7a6fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4aeec2ef9d09ccfe32c774662e40015f0ddee61ce200fdc7863398f95f15e4b"
    sha256 cellar: :any_skip_relocation, ventura:        "5be05f5ada4f3c11b03a4da48fbe550be1d186b14ce5e4372c6e1da055fce963"
    sha256 cellar: :any_skip_relocation, monterey:       "b16c03b305677029a948bf773070a8c63342c0b837c167dced785c7a0ff760a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc92e8d7e609d8c3fbe5ed29e5b354d0e54efcd84b97b75f11a1e9d88e95d876"
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
