class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.19.8.tar.gz"
  sha256 "cd3b4ffe3d6d92a39b0454de2b10d732a8d45ab50df718efb980556cb9f9932b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30a022b9b67d3bdcbce4ad63c85860fc2cf7757662b3d1cc55faaca975465607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806ffdd8a67695959b47dea02a19e143bfcd0f470663caaaaf9e64c5dc83e328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a00f2a8b1a3c35a23bc0497b6f7f51799c5c145812d815a6ca019897e925d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "27db26dd7e236f4343069aeff70436939cd5f308c01c6e576e74f52faddd4145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a69a7cbd6260261f4d8e0bd5cd6781ffadd464b0d5c97227eaa2f4707976ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31d60ddcd07cddc2e296a4b972b15396c0ab1d79cca40b2ccae645a35e22f50"
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
