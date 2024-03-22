class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.1.tar.gz"
  sha256 "8ef8f0e2048b10fd2048db27c5400dd1d18be9e4a3a4735b4b7472debffecf38"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89bde8b852c89c6827166b084db2b46e9a786251c2b9b7fc9415f56a6e4b961b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b524244b762330b9e1a82d2684b96e2eb97a8de177ec8420dd375d8c8c9686cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1fcfc14debf86daa737f8cc9045f6ec1b405db057652f913a8e34e8bcc988a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e8b4663711470c185f4d886bf9d39f26e9550820f2b96fe84ba0f312cc5fcbf"
    sha256 cellar: :any_skip_relocation, ventura:        "bc23e990109b510ab332c1af1228ac3cd9d7ee7c5a1efe68be157ac57673af21"
    sha256 cellar: :any_skip_relocation, monterey:       "83077448bef5da8efcd9e17aa9dae51208550f1d17f3c7572c9a4f9bb0402039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f294890d1fe7c0660585cd649d8d24b396a3e6ad75ec0fe22f0193dd84f24d3e"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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
