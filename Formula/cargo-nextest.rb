class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.29.tar.gz"
  sha256 "8f9912768586c307461631a071688ca015049e878459fdcbea6222fe04200292"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f327f73d0e1a888de2b487bc4deeff5e1f9c459600c38d6938ced84fb1550066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62a3ec5766afe2b9976fc0b4661333d61ad45ef23b3ca503678157b88f3b2d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "27589463cbd9e63e8dd91f8cc7bd44f36a589e2ea03d02bb61d209407f730fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef377529455430f0851ff0c8432161ab7d2371a20af1c49e6a3d6c2ce667ba92"
    sha256 cellar: :any_skip_relocation, catalina:       "360d98b530732ea3aa56c93645df437ee26369eb90c4c7084b0dd3414bbc0cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025ae69845db71008fbe1208b10424378a116492d35cd9306285c4d2c5b70b66"
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
