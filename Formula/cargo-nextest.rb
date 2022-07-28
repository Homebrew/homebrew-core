class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.31.tar.gz"
  sha256 "2d14315ad233578611d024e09e0eb44bcdf4c5375701dfaea7e94df906ef5c84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d88d03aac42214278ca921f3695cf83ff6f0f9a18e9b1e63e635f2ecfdd3c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfeb977b69b4481c2774cdc7b2afa4a52325a5cedcbabceb1b5e2e82805fbda6"
    sha256 cellar: :any_skip_relocation, monterey:       "c034c24e7aefd97ada43e06445a07ff19502f2286bb77d987b753180747a37e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb10cfc94e7a60c8d52bec800fff3a2d8fb3682990b3bfe81b58161414380281"
    sha256 cellar: :any_skip_relocation, catalina:       "475f08335e6192ac960f8024a35c6d53c8439c358449ba73fd6f8d13a6fe8515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e5de04f2d60c26bf2e2b2be7fc908151c3ebe4c3f540ad5f2fc5354d41d19d"
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
