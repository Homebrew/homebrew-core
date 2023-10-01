class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.58.tar.gz"
  sha256 "fb8ebd018cf0717067551d5e9428991207575b3c6536832f201853653b770307"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e480513ffa2b0f9328da83c1e5958e391b70e8d6ede3599e5a1132a24c6ceb27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d240eaf20962d7fe8c2acecea3fd02dfa330c5c6c25b080d34cb693837e0762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5135e75c76736845c80e6246a6b2321d8c82ebc75ef5884a70c13149b47a10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a771e3af2c152e4455f7e6b6dcfdd384bfa56347b8a2d0d8f7181ed1bd0b45c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7abb4c4b114e04a8dea8428306a6ab91e5cf5d50e4767f663ac6cc865002b50e"
    sha256 cellar: :any_skip_relocation, ventura:        "b19de879d5d8183355aa0530996f1333ebf66a8874f5d41c82d0518dfb61036c"
    sha256 cellar: :any_skip_relocation, monterey:       "d35587d00fabf4c80acc2fe647e3b2fa4f8ef83201e133ade5c9e7f92f68c9ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fd64728aafd1044e8f46dd54628e7c8cd318ce6dde8b1ff3d344927aa7a6149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc2a2ab390f5da1d5c0f7ddf2d66823468d062129dd260ab5e2a507a1fade9d1"
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
