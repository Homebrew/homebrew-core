class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.8.2.tar.gz"
  sha256 "f12d67fb4ed585ee3406e73eebb9c5f11823fd9f00627e407e74636789201d93"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14c332e8774f2e64e3dfd5aff4b677bdbffdb92a85f83552a36f57994f309588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55391deb209a919b0b3d6d24fff3344311bfd83c25f9e8e810cc2d415e53ea39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31158d1e2b49c9a50b4d77773ddbb688e34497e16c836cec11d7e40b732078f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2138a463c16380d34ce4d413a69e64df915d17efabb96389db907a2c2dd9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5fbea296a1ae531cf4963f7ebb7ffe910981ce9f7b3df5974a734770a54609c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6b7aa9a67adafd9f23da6146c74e5a22505bb165201ac849620bd944263f77"
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
