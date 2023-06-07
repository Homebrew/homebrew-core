class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.53.tar.gz"
  sha256 "29c7c0c78c57fb14aab2d5651575b203efc51ff1255ce83e0eb32807946bf13f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c3c4f83356e2775d8a9e904958b779315edd09311039d0d8a3834aff01e092e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6261efc21cb34f8ca5b30130bc51338cfaefc5e5b0c4c1a643e7944bcf5652f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8060d29d610a9c9d734e3afc7d8e1cb380273946558ef5f5ce42f1cd09bfb0b5"
    sha256 cellar: :any_skip_relocation, ventura:        "2e86c413399565dae40d10831cfaa8c46f1cad6e478e714cef5cce0d6416edf6"
    sha256 cellar: :any_skip_relocation, monterey:       "4332c29d1ad26a7ae19fdb4da2d8ddf8ca60c340fdd828a23e118650e1c45fde"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3e7dc3fdba212355de9380fb1af147b7208677b6e0d17f531af030ff6b8e57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0248a62303dc256dea497f006e60c30210e04be43febd850ea72f4ff1e4df0eb"
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
