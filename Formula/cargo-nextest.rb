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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a400694b25c34edbf84a6ac7e363eb8e4a676b4ce312eca89f8e1af822ef151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72c36135c31dd0411b2612cb27a7c57baa974cef1c919e12bf20a2929bea69f6"
    sha256 cellar: :any_skip_relocation, monterey:       "5c27cfce2968471cda06c02cc0a35b93631285fc5c4905c862d2fc62ab16b5c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f68e87a0d452a5c9a9a413e48008ea4d2088cdb4d593ddb0dbb0c3473fd4a26"
    sha256 cellar: :any_skip_relocation, catalina:       "8133e32afe3ac0ea62f275d485734f9cd3b7ee243e99b38fef11d524a363cbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216736f953414277a704014e2bba5b35be1f88e55900c03538211e9e75260d44"
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
