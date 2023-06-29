class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.54.tar.gz"
  sha256 "69e1e28fd7e3b061fd809a7e17302d5f2a46fa8ebddeeb469225a7f720c7fd8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051a3076d22aafbbdcd362b2847772bef803348e04caa4de4c1106b27027bbf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afc27cc3388763a65d3ce1d89940fa45460ed2ed034cebfb7ef15fb9dfd9fcbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd91334032ecd8aec555230d426f4bf7c2e91e307fb29955d2c922023c26ea8e"
    sha256 cellar: :any_skip_relocation, ventura:        "94756c5a9c64ff8ab2dce36cd49e572afd2658cc1cbc80d4202c4723b04085f6"
    sha256 cellar: :any_skip_relocation, monterey:       "360e2b694ea96f4497b8369439190c3486138ed5dbd78ed9f72b9b80e77691c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "31b9b1de8b2b335377227183da4eae7fee0e0c0b3d17efc999d3e04077a8f3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6033803262b50655e4da28eb8eaf080370a8aa8b523a7b810908702ede7db0"
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
