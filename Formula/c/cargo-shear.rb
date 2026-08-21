class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "93016cfddda03e3862f2d25c63f7c18a100edbbda4df0f4bca1584a6b5a01394"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8c6946d51bde74ffbe441073a1d2a6b732b5a179a74593703072eb29a017391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8df819ba03aac3f2d791f307beac1d4612a0af37132716b6ce1218e5e8b86a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fdd1396f60bd0a49f988435946a3c41105db7d0079e211820db5524472db3a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "965f1147bfb5f3111289dfcc9004366a29985f79c033b5be685b0825bf7e749f"
    sha256 cellar: :any,                 arm64_linux:   "c49dfe03cf94d021718f02df4f1346b85a68721e9b660eb806acd4ff30f4b619"
    sha256 cellar: :any,                 x86_64_linux:  "55fedd67a8c48bb8a36b87222890f8fdf02d368ec7fcb54c0de82238c87b94d0"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
