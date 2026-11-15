class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.9.3.tar.gz"
  sha256 "b0045ab03510136e2c1678576eba56b25e4539f925693fc9443e384cdd654e8e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "361ed227487e5fb3b1178758fc3760f38e45c62b7a75f8718fb98cb457bb8290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38eacf888f9c3e12d500b7ab2ef80c24c311571e98549eef33d80e661748b7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "786530ef6a5e4e09f2b7560aae19128db824fa9d4d4c3b63452c0f364263d383"
    sha256 cellar: :any,                 arm64_linux:       "5b73fa25c0fe0a51363a441e131c06da3169175c3eea787faa030d8c351a4a3d"
    sha256 cellar: :any,                 x86_64_linux:      "0371af1a5787ac59f23cba27c7b3e0cfb14764adc2146c46998f053f25c0726a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
