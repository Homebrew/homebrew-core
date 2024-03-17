class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.68.tar.gz"
  sha256 "85ba57496e814e0d30ee850deadd3b018d00025ac8e573d7fc62f662960b619e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "490916b87ecbf4ab9610bd3b9e343ab0c4046fda67720a44b1e7b43e9d9e14d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5897e78ec733b57b4b620922862733f42d70f8aee3fc88616800f5a367157c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9162e88168483751595d42e646e98c363626f02c92c1d93ec798f95a5e8a42"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8df68a184dffc86bcccb3cc713794aa9c777915819a299bfd559e549f78fe4"
    sha256 cellar: :any_skip_relocation, ventura:        "db3e455683d7124773f04b8c7335ee3acadac8f9d8d208f9639e87577c796600"
    sha256 cellar: :any_skip_relocation, monterey:       "9e6251ec5c336073a2d83c6f4105b97a4269a43ea6cf1c0742d7b1e139d16883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abac4ac26c2f0c196efde72293a964968bcfae4d6be9d06753ec1d23dec11bc5"
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
