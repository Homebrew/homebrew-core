class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "729d4672793369a2de7e120232e39c656f15745e4403cb7af6bafc17a6781b4c"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1938e8afa580247ae121c4a04fa55966ebf9dc1b03dd1b4af1bac58c154c969e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23009702417125eb10fe54513b0d1a8ad2d961344c3849b4bd95074250d047ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fee05e3379620cd24a134b7dadc988969c33587ff4c683754b8d7f4cdb7d983"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ae982afd40edd0eb55179ce3b9c3bf3d1c363f67945eb32a2de3f20e5c22ef7"
    sha256 cellar: :any_skip_relocation, ventura:       "3be5ae926f0cd88cdda979059a69f7e4c3ccb0837147c39de11878a2f1c204ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce5cf7a45afd55c5ef30ea28ab12b7af68ee17a4a55fedb3de0eb1a39af1241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375c8f7853e306f9b914b7b340662bbdece1b5b39d9e766e1332cbfa36a4a0bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

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

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
