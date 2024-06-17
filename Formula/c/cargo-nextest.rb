class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.72.tar.gz"
  sha256 "565f53958bde36ab643c2d42d02e15759b12afa143ba15f0136a50fe4b479041"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "779da70e562c057a26fe94be29e9d43a780bb9ffae24fcef56bb7494c9c01832"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24a06b75728b2205fef92328e6d53595da878b404f14b0beba6a291e54b6dcf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2dd50b52c4f6be294f48d9277fcc2c06fdc3ce48d8097d71cb16394b9ff3560"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e9520c24f3d86678d792766fa2d34f3ac9611ba9c9053d015d88469fc324b99"
    sha256 cellar: :any_skip_relocation, ventura:        "af6bbcf9fc56c5065f3676649d6ae52f50f79b50ee581fdad6a8be1daad4d5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "49725306e29588b122066fec5dee8ab17a401c00e9d46a095c47ccb8d16ea17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ccbb186bd56570ab7d04215a23ac42571b411b240d2e1c243c30da1f9e39e9"
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
