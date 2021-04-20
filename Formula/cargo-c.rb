class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.8.0.tar.gz"
  sha256 "2bcb143317e7f579bcfd13ef3f230cf72961ccc79abb176789f8d1fdff03fd35"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c8953729c191ba319ec09b759ca5ec101c99ad37ee090a829103122a83842972"
    sha256 cellar: :any, big_sur:       "fff7c809a7f402ea1f3ba0decdd12a86e1b2a0b4f469726bac3ac76bb73341d1"
    sha256 cellar: :any, catalina:      "de64b4d0f6d8b2d0c8f8b6e48369156bfe0057b2491daccb8ac3ed236a01f861"
    sha256 cellar: :any, mojave:        "79cca1e025fca5e9f055aaf82da98b7b5a428cfbbdb0401423f2a5b1d81580da"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
