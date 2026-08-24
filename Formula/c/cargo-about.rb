class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.9.2.tar.gz"
  sha256 "bc82b1c4ec112780652f8b8fee043b5826e580a946f8dda68c25eb39bc168a05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd4f2278b491d96700820056b17803518b321e851e94c0a7ec4b549378f8ae23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec6308fdd7ecc6430377fb22c798fd6c6fc067dff62d42f15ed28f9b35de4f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b8c43443843d86b95299e7bba9c463f27b71f67ce82d0b32e5f5113fcccb91e"
    sha256 cellar: :any_skip_relocation, sonoma:        "38527b03590866dc0d72b233bbf28297953d2e0c4d803d603782b7ff4fbb08b2"
    sha256 cellar: :any,                 arm64_linux:   "85d6d7014be27041dc3908dd81cbed59314bb3d7b6d27da604896286bcfd43a7"
    sha256 cellar: :any,                 x86_64_linux:  "aff65ae9a6c5c9a2f17d5f5dc0e83ad211bfae4fa97431bf77f729a0fafe8f86"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
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
