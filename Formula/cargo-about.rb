class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.5.4.tar.gz"
  sha256 "3ad7c295a57da252433a1dd4ef277add2f1842e7c9554341a31a2c3daab82c33"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a37a22fa843c840f168b172584aabde00335f37e4afb7c7060d7cac9fbe3d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f93a9d8e541c20c4b611e51ab16954b239243a04ccd0a9203250b67c0d107f27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2984e82e6f5314ec2455a579b4edea21568fe44e675978ccb952de6f9c9a8ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "28a0656929e072e84ebd2605b04723f3ebd7ab3d4e503973cd4bf55d2ec049ce"
    sha256 cellar: :any_skip_relocation, monterey:       "91875552c725e48a71005d07c34caa4e7bb832b738a5a7b893ea46964266a615"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea1d58aeae6ac4fcdacd5e10261ce0cd5afe1fca7603811a2140d66a4c9cd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0ac09af4b4ad1db5116e76fcb094f2ec535c446b6374261a6fbc12da00b3f2"
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
