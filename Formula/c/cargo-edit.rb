class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.9.tar.gz"
  sha256 "d7aaaccfce974d9a47db2db1b78aa2d8f458d919970a1710256f9b4dbfb09ff0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab62a4ac2255aa600b7c3d7547fd6a728147a4a2f82724bcde983c45631fbdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca8a5862f06f65ca0e5e3f4bbb56ea5bb743d820065c6f9fec63aea89e107e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd1c25d06e9b85597c67ae1aa44a20c6cdb5e56f0d75e1123eeb98b635ec4edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "315c86a642eda0a9d0d3e73ffad0ff0231747996b2b19e38e154e7f717b92164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d74224cbaea3c30e8ce0634d5d413f31fddcc3d7d2fd934057e84ae3546a7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6dfe460ebba68a20048c0a736e6006d026115295fb5826c892573a7968008e"
  end

  depends_on "pkgconf" => :build
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
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
