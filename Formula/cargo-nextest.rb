class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.46.tar.gz"
  sha256 "1e0e7793aea57fcfb123bbf0195ac4db698809c95c1681373dd0c59a0e9e1e9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0035c4755d63f2809f8c3d745fcab00ad1fdde69dbacd2d204615df828cb5db2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdecf156df2f27fc2680200376ca7a737b0ce6c16a4083dbf2fb5b446db1827f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0465dd0b774b4818e9e8878353d382f75de90aaae69cfd5ebfe0d1ae68eab9f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9d3b409d59d439eba4431f40467d7a9e8f9bd8d63d8815bc44eecb87424a8102"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae51591199fafaa740575d07e619d1300609643cbffc3f86f170fe21f091746"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd36435cb5c2c665011be1a95df5a87c0cbfaa590e9d4165dc42d30cbd2f58b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d61ea207363c6a9e246ba9bcfeeab85141b255ed40ffc32d6f0800339f72b2"
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
