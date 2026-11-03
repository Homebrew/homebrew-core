class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.151.tar.gz"
  sha256 "613c8855e6a5b9f9d12920bf74a0c191af3f8b5f86ff4cf27446f0f7adfc44ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2e61b95b654bc3a76b4b970b985dc64bba5b96a4c4f827a28e1c2f40cd0bac7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e27147257dbb08e78e336b40cdcbf60e414c298dde81fc58c02e252b7136f67d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2c2465e1fdc4806549d8b6d5a5cb7f080f34c33fa346923e5fc2b58d448bf17"
    sha256 cellar: :any,                 arm64_linux:       "8e7e6a24d3823eff1e46de3f545303129a394c26d74b469f3be0602a474c3ab3"
    sha256 cellar: :any,                 x86_64_linux:      "64022d938a0fb7ea19a617b483e10333ddecd9af419b5427ad6688210848d1c8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  # Test downloads a beta Rust toolchain via rustup
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
