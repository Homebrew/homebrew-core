class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.9.0.tar.gz"
  sha256 "7dc9b5f87d25b57c044618655a1948857bd03196e3b20cbb8700b41ad6f1614f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04842b326e645c0747ec5aa0c3f2036235970539066c94ccc0f5041a878d0d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d57e5c3c2684f4a42136d086c6a0122014b61818103aead8ab6a1e03edaabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0161eee173a9d531710dfb63a98eacd28edbb62445efca9684105c41a515c28f"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a785044b6ad436c9f18611f3c5fe968bcc57425587a4f4c43ddae86b05d824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42514005456e43508665079e9fcfdf8407825d46ae7954647483ded47e0b9c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e137f847b38593df5da9f42b86ad7cc237fe6857291caf4130ec636673569d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
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

      system bin/"cargo-about", "init"
      assert_path_exists crate/"about.hbs"

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end
