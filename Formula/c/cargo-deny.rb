class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.1.tar.gz"
  sha256 "cb3f49ebcdcd7c90d6de2ac82f40da3a509d9acfcf74e382afbc877940ec3245"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b94edd4db13cd91d2b803dbe42fc0848e051087100f0ef708422860044e9a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74f126f978bf452f207b8016aa2af6aadac63ffed43685d0215081a4da11afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20fc6534c0bfd0149ea887fa41751b07a5a07fe093654c084e1caa9748f0b978"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccd17b9eaa1cee9dad39e411a99b71c85e751cc324beab9114b9a4a1f54a84a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4762fc62a26400cb1e0577d5a14007e7b88c94fec4aec4ce297bd2427822838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bd9af799be7a1c2a32c209a4a9b4ce1081467558d3ab964710bde46cda5d71"
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
