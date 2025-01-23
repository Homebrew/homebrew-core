class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.6.tar.gz"
  sha256 "ecb67a616c81e813f3435da28f046b9f9e7519870a264589a62fb705081bdbdd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e781f29bab8727a985f32317d0255446bb22cae5c85db41f63b9f4695da3a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d921ce0ed093640baddb410d725595cc4ad420caa010c351b84f6910891ce0e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e80aba3a92619ac3a0543e9d5d73c8cfb4c6447d87624c6b7ca7fbf58dd0d212"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba6784a3246790e22995903f96779134ec71548faab02f81afc8ab598c99710"
    sha256 cellar: :any_skip_relocation, ventura:       "da6c0d81527af5a0f1f52fddf48179ff65d6e2de797f2daede1cf2608fc12e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b594e161cf8e9f5014877ec3cd73247d430439820e82a5a026d5d0ad57b0384"
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
        license = "MIT"
      TOML

      system bin/"cargo-about", "init"
      assert_predicate crate/"about.hbs", :exist?

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
