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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01aaf016d3f7a9da6710ede90011df26510a767b695967e94c2923c463705a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c66adc6a29a858f691da916f87ca07f080f486e5c7cb71a2c89b3f8e93f06e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "478d64a4eb534bc3c2301aebafab5e50bd5cf949517c0a1ac830661982c7d324"
    sha256 cellar: :any_skip_relocation, sonoma:         "222435f08ad25c61211ab6dda946738a478b48533150fdd1a087d0264d063e88"
    sha256 cellar: :any_skip_relocation, ventura:        "12ab5eaccab5be9a42c88b4bbd4906ac283b4f18d63c02aa64e1229a525d5f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff1da8d320c3875f46e538a788a0a1acb8c6f92d5eeaed84d97c9cc9a1b0036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405ee3f71dab81bddab7b9affba82a4568ba8c3d1e5623b17255d5ddabe16aa9"
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
