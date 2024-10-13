class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.4.tar.gz"
  sha256 "94a3cd55e82fc8adf99d49e311011a5a9a0fb5e152a45fe42af42897c451484c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f13afe3c7cba7829ffebdda2f6640a307919c08c8797d4cd1d1cae131b3689e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "768555e743f08212e1094ff863df1647e1788d2e1bc7d18a2adbe924b0bafcf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1bbbef28b6a388ec303a695f9782fde0bff74e90231a68132653dccf1ff8853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45ecb6ad67efacf0ec6e9e443b7a63b5d236ab73c76e507081983edd6effcf17"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1867cc5664efd5a3abbfcf1da38add4b542a6e78c55bbe3c7a8ba7dc07d5b1b"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6eaa1acb17c4463c60b9e23be9cb256ba33580b9c6f3afdab4498f672805b2"
    sha256 cellar: :any_skip_relocation, monterey:       "678fd7116d6c971b79e82c1d67f256db2d8605f7f314f85ed8c3d65b783f6f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39acd6c335c949d8e8ac4981ef0ccaff6f061f4a3ab1f03f013e96775a942af5"
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
