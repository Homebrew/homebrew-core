class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.70.tar.gz"
  sha256 "c604a391c1bab0b642e045ba31d4eeb3b4a0dd992125b8ccd8dc55c578d84fa6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b0b37b8106b8659d97434ea9d9a3f15d81482f8781583b8fd359b0c6195ebe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e06cc307099f33cb7aed93bc08ff69eca3b162b3e56f480fafdbc0764373d7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9377b37985cc04747cf278fafcd01c1474b53f60f8662715da339dba34bcd170"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9f59504e8440f115c07e166369f3e67aceee05b5189dd17d479a100f0137103"
    sha256 cellar: :any_skip_relocation, ventura:        "215aea15519aebc2c59d124b57ed282b1c3e0003dfb2b07f2a24be292760942e"
    sha256 cellar: :any_skip_relocation, monterey:       "0b11f7dc94bf221bf54cd1a42b014a162c85865abcdb2129eb91dccb8727feec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55485b808fa14f34a689272cc9e51e11d903fc81bfaacfbdf7bd8fe232fabf90"
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
