class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.8.0.tar.gz"
  sha256 "753c36632d590725386bfce9963ea042eb2687da94f55aade9d0ffcbd7128246"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e73bf6e2db27ddb02fb6a73bb207308c7a3e52ba96c1c9a75ceacc5b52be281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b2a4440ab508f56fe93b9fbf0d906e5bff31d8b06744c3ad15ccf03aed522e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45aa89dcf3d7aca2d231da56c3e5498285cdcc54edaa8e34a396427609e9fb0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d06052d6132f3ed8338fdc9d298254064c69bcabfbfb7d22461d109a5b75f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aacc4f773f76881135afbf9db488fba16a7998cf9f0f1231f355017f9b1752c"
    sha256 cellar: :any_skip_relocation, ventura:       "b3dfcc8a118c313b7b42db257bbe16c8e7bb2957ccb38ca7770ba23bccb97243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa96e94c34b3d4a09e858d07a238f83d6e144b595ef6040ec52c23ccfa4f651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3d335511ceaa356ef5783a48b1a6c9c19b784e11a0a5451c164a29224c2e0a"
  end

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
