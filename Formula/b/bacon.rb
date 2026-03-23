class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "ee6ea9784bc14e404a3dd11c2deddb4b75d597e29b645a57773011945a664f8d"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268bb427d8ee661df203675928dd285c967dcf7623633448541f58a6cad0330f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908048f3d7c82b637e1b4290388daf4c209ef65a2a11b0cc4a8c3588feb6d24a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1877330c9596234df01aeaf28093424c994eef378575f16cb4f9e834ea47c539"
    sha256 cellar: :any_skip_relocation, sonoma:        "973e04ecfc46ba54111f004a747aa542e7a88df8b49936783fdfb5f4b1ba6cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d24d9a034321fc5f2c08d303c278eae8785dfacead8c19a6f654e68b94d805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd39e0e50e4f24d54f199891b05ea7cd88fc85a514fe39aaf75bec399d86591a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

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
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
