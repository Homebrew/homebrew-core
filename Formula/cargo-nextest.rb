class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.49.tar.gz"
  sha256 "da22ed44da58441e9a32a105f9786c3d2989360fe7aeab17745506ed008d6f9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84dca32212ef4ac31f7e173df0f952376213d3b0be4785d9519c11bb7fa8dcda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98460b4fad62b8f7e65c24f816e1a0a9351d2c3b0f520ca933c8ce3f1712190a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad3ac172ca35188dd11c09aa9b46d1247706e481ea29dcbace3c9fe2368c8a3"
    sha256 cellar: :any_skip_relocation, ventura:        "e45ea216cd5851a77e7970ecbab136a15808ec6e0c2d9c791ed50e6ba679478d"
    sha256 cellar: :any_skip_relocation, monterey:       "da39055291de849e06ace3ad8205742fca043843452aae8e480c7a1d7d460c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ed52d353cdf7a7182f47d5316b9e48d8787fe73e810d7b7590539dff55af23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aeea0ec1cae5647658267ea88ba92e4bda8de700d4b10bdf11642a0d025200d"
  end

  depends_on "rust" unless system "command", "--query", "cargo"

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
