class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "43a15acf51dfc053746cfc362d0c236d2c1b215067a6ff921bca74b9e4dbf554"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ffe55bcbe0a5e6e20fe552bca1dcede976dd6d8a060247a2385b6cc3616d3951"
    sha256 cellar: :any,                 arm64_monterey: "5621c5aabffaaf4ad8e0b490a1b1702abc39a516e4948e3707fb4c5974374984"
    sha256 cellar: :any,                 arm64_big_sur:  "d7149dbea6426439a6a89f99958f56806ceaab0a96fb9c2304dc37523edc7ad2"
    sha256 cellar: :any,                 ventura:        "d350dcb7a6ef3d223b52075536e0eb23b45c8ad2c3fe93c6f40b615a5118f6ed"
    sha256 cellar: :any,                 monterey:       "469bb7aeae3b42dfd7552473d6125e1f220ae5b8c90632f51332c354a367c92a"
    sha256 cellar: :any,                 big_sur:        "e994bb407e01eb226f3e1590412c0f80f008d45dac869dde2f26252b85d7ecd3"
    sha256 cellar: :any,                 catalina:       "d2f0a47d7d8787946be0103477f31fca12474604e21b2a55ce75bbad942c5074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf7d275459b6d970be18eedae5a3268087dd09e0a0ed199b4fabf237e9baafde"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end
