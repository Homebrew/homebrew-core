class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "556b3a6a4dc8e7bed0c633184a70a8760d3c8ead453adac094876a9125769375"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20283592925a6ef60504b2d1ba0ffef82fefaba9bc09735112b480ea021c5ee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61efc6b3f1ac8d412a212a9f349198a805be67424c769f28e8a82772b8681c37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b023554e0fe140cd73e46d5c56a319b119015013ff46c6e2b0186d35db24794e"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a351fe717f2d22f49d328db326be9dc3467dfd47486c0ca7fc411c73c67be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae52bd015b7aee5462fb1c1944c0b5616f1c83773874835752207fee91e1d1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b15422cb735c9e84001ad2e72873057068d123b3da92b6ab703567e3c4596d6d"
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
