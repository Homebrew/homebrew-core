class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.20.2.tar.gz"
  sha256 "31fc1d33fae8d5b4264db8ed5c6c070c27cd2f869cc6d2983ac03548c5a81c8e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ce04dc022e270c84586b96c9cb36d5d2dbdccfc265bb7fcdf6ef3c7efcc3cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435197f76fec67b0eea9e55f1784cff835b1902040769129ee4a701f406fba91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ecaebf8b3bbb03018bdb1a66a00aecd5798ef2f84ee33be21728f3b60b907c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9bfd9373d28dde611de1a8b7fa517cd81b1e32804259ebf5049a86854da58c3"
    sha256 cellar: :any,                 arm64_linux:   "8cc4e141ff370be3d6600d6672fb7010b5b1799e85c5effea2ab9172c15730e4"
    sha256 cellar: :any,                 x86_64_linux:  "6440ce44b036e0af6e77d49c28b49ec3e180660e788e18a71407f12e63de53ac"
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
