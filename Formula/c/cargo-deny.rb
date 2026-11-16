class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.21.0.tar.gz"
  sha256 "bcfa93ae07a8dbe4f643c65536266ae0dd8bc26ab4e0f813072a0e898a45591f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e08036343c95ebf8c198893017f1fa3a92bf729c307ea4b0fe733b6a3c17450d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df5e7c6211c6110e041424ca28b3764d7099e4da2e8d70c434317c880c877ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d76adbb8aeaaad4bd559b1b9158c937acc36a7c8449d5196662471dba0200b48"
    sha256 cellar: :any,                 arm64_linux:       "6669badebd01b552db5760dda9e87275c79d51efb28dba2e43b42e22a3f495d3"
    sha256 cellar: :any,                 x86_64_linux:      "9e7ae98bceeadfdfaad389f806bb54a690f25059d7dc0a7ae82f2913d5a7044e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
