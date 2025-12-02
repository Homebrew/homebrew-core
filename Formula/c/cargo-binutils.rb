class CargoBinutils < Formula
  desc "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain"
  homepage "https://github.com/rust-embedded/cargo-binutils"
  # missing github tag, use crate url instead
  # upstream issue, https://github.com/rust-embedded/cargo-binutils/issues/163
  url "https://static.crates.io/crates/cargo-binutils/cargo-binutils-0.4.0.crate"
  sha256 "1656b16634e00e0b9f55bebc83f2c6f021cead99cb08aec52a7b9395563674b8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-embedded/cargo-binutils.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1462ea07e63a12bca4c626cb452706ea56780f777a580ba4080c87978b661af8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e345e71200c674756c1c5052eb06d5c5476ab91b0446b2f53fb4d21329e86f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cfeba9cff1b593ea7a254f326889dc486aafac59023839634e961136c19bb60"
    sha256 cellar: :any_skip_relocation, sonoma:        "5abc3d0339e2790b66b6a2fbc35efc00b80b6738194e16306174debe08b02a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d798e56c93c493b1902da4a8e741093f1cd6dff28ed0ac50ef6c4da439fe52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02d15c4bedcd6f632dc69a1d2edfd39d8bd8e4388240e0d7e2823aa0fc88d3f"
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
    system "rustup", "component", "add", "llvm-tools-preview"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        fn main() {
          println!("Hello BrewTestBot!");
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        edition = "2021"
        license = "MIT"

        [profile.release]
        debug = true
      TOML

      expected = if OS.mac?
        "__TEXT\t__DATA\t__OBJC\tothers\tdec\thex"
      else
        "text\t   data\t    bss\t    dec\t    hex"
      end
      assert_match expected, shell_output("cargo size --release")

      expected = if OS.mac?
        "T _main"
      else
        "T main"
      end
      assert_match expected, shell_output("cargo nm --release")
    end
  end
end
