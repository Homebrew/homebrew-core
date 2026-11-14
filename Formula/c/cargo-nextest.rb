class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.152.tar.gz"
  sha256 "b93dfdf2c5d187f0154e71ee86bcfc40e8ea39abfe7bf20f95f1fa05c12afb2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccd6b8f43eed3ee35cdac508c19b1853e4e1dc682b24b5c3d20b561edc4790f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ed4c8463e02727d42418e7966a7d3f025767a225fbdf6c58e393a82e186ef24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1cab6c279f474d3b1f47afac4f43184fbc9a2857a9217259ac5c95112b3101d8"
    sha256 cellar: :any,                 arm64_linux:       "fa1f2a4d08f34e78bc88273d5f66e9c2fa586649dc8d82a4ce39e82149635a48"
    sha256 cellar: :any,                 x86_64_linux:      "31024c1c61a159451e25e10765fc4acac2b507abae1e0ca93b91736838562022"
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
