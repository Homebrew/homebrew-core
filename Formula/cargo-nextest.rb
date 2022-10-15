class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.39.tar.gz"
  sha256 "cf612da8c9be80366a5874219d2fcc9f48f1a04f000e956f15ac4440867be253"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d454a32dac7e7897fb6ffd699342e6501d6a4e3f733cab32d21147cf76c775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3854724b2250b1252bae4f3d1c025a57744ba4c94532d9bd46517022d03d011"
    sha256 cellar: :any_skip_relocation, monterey:       "f2e2dff812b8dae671aaa00b999cbe20a87db524579b9ce02c84b3ce074da20e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b8ef3b7a2f435d8bf50aa1f20f7a242f56aded5ee2eed3eeea2f3e314536807"
    sha256 cellar: :any_skip_relocation, catalina:       "cd78a8e8e82f05428269aab2542e46d37e061e94c748188d0701e3a72b9184ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7289effc4a987e3efbcec93b44b479ccce9c010ba4f3a797c14e1b457afab2f7"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    # Fix a performance regression. This can be removed once Rust 1.64 is stable.
    # See https://github.com/nextest-rs/nextest/releases/tag/cargo-nextest-0.9.30
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["RUSTFLAGS"] = "--cfg process_group --cfg process_group_bootstrap_hack"
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
