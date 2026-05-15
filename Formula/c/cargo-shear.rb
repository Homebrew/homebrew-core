class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "f77cb15a7955d2d4290bc77ec09a2c70984e678955df9cf4f23e7e2d3c6a3737"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea1eabd951f9cecd61ab024010bc3088546daab9b6fb8ef022804ffad13d99be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd356f44a8e7b8d323042f2959fcb59ec061bbda3f7356b12734ba519b77946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30b00036c094f7b84c6a6e6817154630faaf366f83f35d17182581953acea2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "49785f5a20909d7ecbc555d381c6fac0bd101bfb7ff48cc27a43924e7b592a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8212524cfa390080cf912b19c2fadc2a6c06d90c1b6041266862617d8101fc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c3d95514321489bb94c7931439442369e7cb59f194d5365be23eef7b1a5ea38"
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
