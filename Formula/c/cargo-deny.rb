class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.22.0.tar.gz"
  sha256 "0a80f1a7c79a5ba638e88f33049c4cf41aae71d86a93404a20a8d3beddd1ade6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a296b1eca42b5456b10e0908b9b7e238f7f9dc53db42e92111ed0e31c99cadb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9658e93484de535bbb6b38744e93d32c55a1cd8f32915aee7d14eb9cdbc95dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92c299d2f17266cd599db2a11a8c60c8c6214efd2fbb5f825adeb8b8f98c30f0"
    sha256 cellar: :any,                 arm64_linux:       "4d2ec6cff1604b07c1cbc853186fda676c30ee20bb4c6cf7d04272a1e7765c4b"
    sha256 cellar: :any,                 x86_64_linux:      "f013e9cc8c75f7ff7cf5e6fe41b89e30668896af271c0f498e552c5698daad5c"
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
