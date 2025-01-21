class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.16.4.tar.gz"
  sha256 "9b6bdbf90f2610203708065afc653b9e1e1ba8cc425ffe5d8957da68d9347c01"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c0241d355cc5866836fc9b30dbceb08ba02fafb2e6ca8e0d8dada1587cc5cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b66c0a3d9b2b0184cd6d0b273cdb8fb41bc404db64bad4af8d4f0e525246fe74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fdaad876292d7edbe97210d396a07c3d4d80e40f552fa5ca96bb4216b39f891"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21f517d71767c03800105de581144b33f4c07c1fdb9c07d5f9fbfc2ec3869ec"
    sha256 cellar: :any_skip_relocation, ventura:       "cdfffd3cd44cac1dd932509a629b2246707b0296d6b5eda9d0cc35bd1ddfd900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190dceb86b718a857a856f44790296cc8ca2981aea4ac1556abb7ba9839977f5"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
