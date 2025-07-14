class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.7.1.tar.gz"
  sha256 "5b090871bda2c2cf645de826c219b41486c36ffe0b474ad9f6ecba7e21d279a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8755083c1b4ab12dd0334783541f0e9b7fff6e2b9edb2017a49dd4c6af18d7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee06157afe725b88b4795b809cb08abb926b8adc6bddee438d1514b771fc4c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64e4117ec95d2a2ddd8d511c63241b3950265229bdb991cc5e642f12497540c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba17839b1dfea081458b2d89cd291f18cfaf2294b6500eab076158682fb82906"
    sha256 cellar: :any_skip_relocation, ventura:       "3adc4e0a65a778755958727f8f1240d97be68bf9ffb64abcbba43aaa7ed9a49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f8960efed03ccbbb12f52eb3cd13b57f47ee41507b7f5871899651c722c75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb409aaea449ed566e5c8bb9c0d6868375bb95761621dee4cea426a86cd3a394"
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
