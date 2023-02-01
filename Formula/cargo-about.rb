class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.5.4.tar.gz"
  sha256 "3ad7c295a57da252433a1dd4ef277add2f1842e7c9554341a31a2c3daab82c33"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fcf7c00ba86d85050fcd1b8f4a8f5b45c6e500004a588243b9d8e9de3a934c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdd8991793007bcf69e1a01e85ae09f213629f1863c7b7f3fbb4a870833ef1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be4f3b429a2c49974b2f346c5062efabdb350f1680ee0027457b10eda2f0c99c"
    sha256 cellar: :any_skip_relocation, ventura:        "ed1c02415e18f53f36f46b7c995c5a0dd5dc5a2cf1071b1956adc9387aaa421f"
    sha256 cellar: :any_skip_relocation, monterey:       "cc4d156bcb5b91d5be52c52fb709e0127484e9c7ef9c0f8ae20745d9ce615e81"
    sha256 cellar: :any_skip_relocation, big_sur:        "92bd2872fd066be81dd60980b2814c49b30c4cc82cf025f96ef4f53fe137675b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2eeb535a6d8eda627e8f303497de0615866defe3fdbe5b73d49b907bb43a841"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
