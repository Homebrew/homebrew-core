class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.6.tar.gz"
  sha256 "e852cbc4effc3de40e0d77066898234aef014f6740e61406288f56c26cf58d83"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "435520abd35c8fa3c0f863941e7b3da98fc1e72883bd37491ffe9c7b22793b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "870579598af251fac59e4785546504a98d83f005eb0323fc17a4bbe8524025ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513ac4967e589304daac884ff697edfe4f5ba127838ec03a245506dcf697d373"
    sha256 cellar: :any_skip_relocation, sonoma:        "88fe50ac8f4f860a8234439b8a5ed30d87dd12945aa4aa38426ef91e8d697eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15cab95c51aee6449dfbfa88b4b38f590518b902227445bca33da9ea89e4aa1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8435954002a69180aba8d2f64f9ba85611df4505f211159bf6f5548697aad18"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
