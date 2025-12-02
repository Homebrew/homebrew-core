class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.6.tar.gz"
  sha256 "9f4227c5eb94011cc32601e8f2acbf6651ab7ee632cda2e5e05e242207a07d73"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7515ca38ba4113b9c1c2cb1073f3a66ab0e72c3862c5dd66b23ac1350afb97c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7fa38112521dfe80aff634719933670d7c85c7aa2cf6ffc90ed1f8714678f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d918cdf862679605b7a8038fcafaa378784c70d095541f23d1d73ab907bb8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a3f8212d67c269665f6948f83fb5423e1271f369462a6d572115d28eac7123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393d692bfef66eed2b5e2fd97624ab090d27e8943a72a7e57f49526f0d325456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea0d30b48cd625522583eaa12ffca62a6b7bf0c54529f2cc70d4d88978b8b09"
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
