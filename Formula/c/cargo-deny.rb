class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.2.tar.gz"
  sha256 "bb47741fada886c166e2a697a87fe93fca38ec083db489d404c73bcb0b9d7445"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0592131ccb6025361d97a51fcb9198336d14809c5e7bd705ba629ae241f296f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7974da7053e20916a07b5ecccb5b38f7a59059a211c059d6e6a3a81de92679"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff7e00cbb434a02cfe6d2e924a49f38778455021964ba4743c302b80271f06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f27b7f9afc995ecf85cdc1ce6bd98f9f10fd280b7ccad29717c84bb2a0f145d5"
    sha256 cellar: :any_skip_relocation, ventura:       "f1369978990bae8e590f0487fe539903f4e3bb4b486d343bdfa4d29b675cca20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81edfb8028297a6f43ff8648afb5ce052199a1b27bb671de0cea1c392c8c42da"
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
