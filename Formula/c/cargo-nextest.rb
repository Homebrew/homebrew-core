class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.59.tar.gz"
  sha256 "5fb00bcd13eba5b08deeacc39dc9fa7be244e70eab781d95b525a61082d47ab5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fc4fdbd6cd9f3d5a6c62441fe6c4694925609b629195d56af2f575bd6872dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67021a529a852d4ccb1d0914a2c10662e2a95dfcb34236dfba832225dc97281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ae198c5fbf567689758042821df7d67c6c0b8d809c01eb27d1e312bd559017b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9715477309bdd3796ff8b11171bbb30f2a229661004cbf17e489906f742e465d"
    sha256 cellar: :any_skip_relocation, ventura:        "e428fee1a1651506cd2297cd6edbab76bb07b4cd209aa7f3848dc95739827ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "90a98c02091282ce4db5f9b37f3f7d4b0ebbe6cf3f7ff35eab9dac52d43c608e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1291a7b375d0e683662404eeea77513b51878166107bb3ce06d471f890fe0d02"
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
