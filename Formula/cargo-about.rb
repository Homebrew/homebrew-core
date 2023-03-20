class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.5.5.tar.gz"
  sha256 "04531afbe3405010abb35b761b9629f784739590253cb7157b337419b1168208"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e117c22db052e9f5dbabd923c38bfe9d81a1088afcc2578280d590b8937cd257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b39957b3c6055441fc2801b456e9040104881bde4d8b364c861919e64f78b99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f865a645b2d2cb0c1689f615229fffff21ce0c3d2170cb941e41f156790e7b6"
    sha256 cellar: :any_skip_relocation, ventura:        "db552e24f1db5c38ba2c01a1753045deae82b5cf04a564150b28b2fdb25e603a"
    sha256 cellar: :any_skip_relocation, monterey:       "96c51eb39a7f87c4b5a7ac254f9e3d5de5cc25966d73e8538d3abbc220b01dd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "242b1a7b15d4e8b0fdeb761fcea1de9a594c7290b0ae1a65bdaac13d088f92f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b30a2cc000b593c05fe2cfcdcb08add2e9d20f25179a783782f038cdf1079a1"
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
