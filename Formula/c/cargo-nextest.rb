class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.57.tar.gz"
  sha256 "fc0c802bf0eb8bd082d111b3e93bb823eb59575b689c049a573d6e762d0bda72"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f70c8745c4663e364d8488e810e1acb440fe37506cdf674896a5ab56a46614d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf32be4740da65c3708445d9911b9d10fbbe11f3b52f07f4371f1f9b1ad2d35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dab0a52f1adb5efe128a6bb1aa06c90ef0661d350bb44e8b0840c6c39fde5103"
    sha256 cellar: :any_skip_relocation, ventura:        "adad86c80616c99f2a35a0cee50d2752a7a4fc5413070928d732d152ff6c32eb"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7114f78519e06e17d164a6d042483f69f66ba576ed334c7686301eaa9660ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "114c7a9b263d5a9a9ae47d9bf45fb6aac5dab274f48b4b07226d6be431ea992f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c34557269929d034decce2e19af964e91c00a1aadee429d7e9743e3446a8b6"
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
