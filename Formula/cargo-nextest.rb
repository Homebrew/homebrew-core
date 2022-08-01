class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.33.tar.gz"
  sha256 "f75c53b4df3c72ae5a89e75c15d571645ee6719d86bb1171d64d0281eb71361f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c7b86f91a5a05053ad82b388210e806062309218dbadcf1f0225725098535c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef01c8bc5ca7bab7d1e3e9fee793b1f899e1da35cd15727cd0f0bb22e9f5d8f"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1dd3eb64a8d3951eae62893ca2b45e059a30a1fd72c7e8df81890aa1e00ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ced711c1a453d25da96cf7f30931f6170523d476351f16258ab436bffe0ebcb6"
    sha256 cellar: :any_skip_relocation, catalina:       "4ad016f26530d4c3294ddb50b90d51473706444297ca7fec868de0f447ca5bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b0dd76a8dbafe4098a4381168913a06ac27726cfda0e1b26175d9959aef012"
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
