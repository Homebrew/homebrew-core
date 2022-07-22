class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.28.tar.gz"
  sha256 "6bda256802791c526b28daa5264926df799d157c8015723f8cc1976852a0f36a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d0f27d6246e6e152a7cede43e37469f44ba22fbcd549e79c741d9688c7df65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba88aaa125a8d707bb931245785baf710bc106fbcd1c034482b420fffd1ecfab"
    sha256 cellar: :any_skip_relocation, monterey:       "922cb2821f7f93fbc7f65323c7c6ed2f9656c9bb018a2f22c04d4d1efd2357b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "34fd449fd713de2c4586c300bb089bb7d499f71320b8be3215fd3da1eef1250c"
    sha256 cellar: :any_skip_relocation, catalina:       "da2167c7f9a2a6d514e89d8fcc117b094834df598d04ed23d98bf4dd89751e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc0609f0afb838090f3518ad5a44fa9474b8cc5150619522183afc7bce39fab"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
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
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end
