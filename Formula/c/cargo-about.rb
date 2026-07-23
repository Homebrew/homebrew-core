class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.9.1.tar.gz"
  sha256 "628dd50f8b89078bca6eb7e615f891e0707209c08c94eba1c4326d2a08db53cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfa8fc52c6d4d10db49faae6ecd9de76db41f272e7074e8e8d243bc41d8dfba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc39defa3517c6a233f002d4b0d9377ede7e3d7a6dbbe4dfab02923b5ea1d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4425a408b6c3b3a03fdad9ae918c85c3f13791166019467a02c159d9134f6a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f928e8efe45459cbb6d78b957d8ca43ebae26e466e6c9979b4c04cbd511205be"
    sha256 cellar: :any,                 arm64_linux:   "dc8b4c945c4c9caf838aa140b8e2d4823ba4b0388db4b7a044cc314e64e545a7"
    sha256 cellar: :any,                 x86_64_linux:  "d7584a3c5f2bc8ad8b261295a1b32c482d3cfa763215aa9bc453dee71309feb5"
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
