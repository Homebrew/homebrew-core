class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.3.tar.gz"
  sha256 "4d15dbd7cc653fcb53a21e42b0adaab6b501693c939b76e4a7683c04a4a689ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fa4e65cf3c2ccb59c3cd81a0a24c0fe5b5899ae8944eb8727da068a8c6fb656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c00a1f08fa03638e78ba78bc7625ba313b3ca1e22639149c082eb0b73cf2bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "836dd971390f2106344029e3f947536bfb5fb8d39a965bb64ceeca67248ddd70"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c75615712ca4ac9ce3dcfef2d5d56528ee62e1905f5445e31e97a5d642940a"
    sha256 cellar: :any_skip_relocation, ventura:       "4cfd5cbef7f013b6e7a7e9fe7257e098049abbf3bb775f90a977df4e09a089e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe53d784ad55fe89fd2f570750df6d8d1bf5b132102145536d9832813fbdf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e8efc03b6b230c4f921347914e5561c4a525d7eb5b4e79b3f6d503946f1031"
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
