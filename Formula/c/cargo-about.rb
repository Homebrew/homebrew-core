class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.5.6.tar.gz"
  sha256 "4f4115abc4e7ec12a70acd3a8821a069dada63f29c4a3808d2a55fc5e7770dff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eaa8f43ac9f0734530c692d1462003aee56015775b46084fbc48fbaa161dda1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71e2265d82f33cded2d4b67241f87b90da678398bdc3e68344f1656f59706969"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb52672f2c7125ae1b07348174b3b79b412b2f06c7467a965780555dc4dbcb0"
    sha256 cellar: :any_skip_relocation, ventura:        "5408f23f9e85bd8ab7aa1679a2c0fc32b5a6ed110de9046e49adbd5607462916"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1adbb0f1fa4afb1c90ddcb2c7543e7e8d69c90a391a7f0042f9a88d25d5ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "79cf310b2d44a3fa9fd6561dc22e255948e74971d28456909313d63489a72704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a4332e514b820eef4087bcd2d985d17f633f03d35c97b2ffda12cf82368f34"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

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
