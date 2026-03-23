class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.8.4.tar.gz"
  sha256 "956cea9d2170936e7d53d1a8c951242332777be89bff4b8531066bff584fbcd3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e117bc49a0b0136e1912a2869208cc6cf10c09dd00d167bc059f5eca47fdfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e29cbdfe8555512c2c671485be5352884943b3d6cb4e03e817c352e6c9802f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "666cb27598069e3b82558159b3cb5bafe1cdf95528d7f02841c9ce8487aaadc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f23c95ee75095b2215aa9fb5b7c0e36da553ca2fa3777a976a40970c7bf691ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdf084e7ac1d3c70c6abd688c9e827b3bc2501af8c86caa7198e61cdd9a56af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9ab1ded1a289b0a63393feb59d98d71b7804f82bac0d660242b684a7bf7907"
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
