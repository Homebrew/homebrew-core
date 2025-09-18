class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.8.1.tar.gz"
  sha256 "909587cfebfe094fe0d1721a288eb280535cd61ce2e3a2046085a32523a564d5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b358b770d9a704379e58799cdc6c64f2cb831e0ae3e08d99ee047d80ea1cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186b56adfaf9a8e47ffc931591fa65c0d502d77bbfa3d86dc044719b792bb294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5aa18138065dfc98e5dddcf412e002b03dd646c8f3f648b6c6adda4bb18867"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c1ce66b6d3000dc08b38081c94c6a63bda1b380a39ca3ff2e7ce4c6af54eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adda161ce59eabb761085e27279fdee063a7129636f90345f338b6773a8acf02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae125b5123f6608c9156840862991de0402de362f01314e57e1465393b26d19d"
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
