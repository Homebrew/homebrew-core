class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.131.tar.gz"
  sha256 "537397d9583ad40f92a0ab2ac018a6677526e94c337ee1abe5cce4cf198ca130"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86b67c46517b50ecad54df48712766ab93b070f66d9fc73abc0695d73dbeb857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7717abdc68658f6a88146f7e85dbed09bad85595a271a49f15ce5cb2623ff4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ae2b5fffff612889c00136864791095a63da9bd70f384f8ef41639fe1af0c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f364506b28cc5258f71970c1112308e9cb1e5f7d3c1b4050a0987533c8420e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1d08ef5b20cc6b69ca7907e62154a381156156005355248c379b1fd78e4f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71a7a47afa34eebea8169447997de12b1e2adfbad6f3547fcc8a53fcc95f10e"
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
