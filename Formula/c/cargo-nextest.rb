class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.149.tar.gz"
  sha256 "3f1519ce8c3ae9e0442c0460995ed6802b70a73597b5876531f96c641577f21a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2eeaccb9407ffd456f4ae9148f5e2fe9b6a2eb5d2d1fad2e2f12b47604aa8ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24a731a9cbb1d725b81c6ee2d356b3c38945bcab4d15f781db3423f6852e28ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f5c1a236f70ff4bb5c77c0079d18d85a44748e715af0b16a538a1862681f81c"
    sha256 cellar: :any,                 arm64_linux:       "66214165e4982b64ce413f8ff9b3f28e9d0d890fb7e25c5e3d7f633e630248fc"
    sha256 cellar: :any,                 x86_64_linux:      "a3b3fb20247514c73ec57a4e23eb465e3cbd3076c2139a5a59ab9a8a63e3cdb7"
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
