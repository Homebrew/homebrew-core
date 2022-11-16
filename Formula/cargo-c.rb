class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.14.tar.gz"
  sha256 "d79c12eae1460803a1ce8b440ae213dc4df63a6f2bf39ebd49eea1d7a008bec6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f20981660ca656343f3898b6e45438ab508a88a479e72402072d88be6bab558"
    sha256 cellar: :any,                 arm64_monterey: "705352ea62e3cd9feda13fd845921c0241812132d699c3bde817a32cc0dc3c68"
    sha256 cellar: :any,                 arm64_big_sur:  "8313ced682fbd30f835876e230ca7fb4c5552f3c8ec9254762b0c01737c7d085"
    sha256 cellar: :any,                 ventura:        "f867a8b1fa3e9c4e46523f88197904531b1e5a5c36ce0292d46fab21bb1f6a50"
    sha256 cellar: :any,                 monterey:       "ea617012ade816d7e233dcaae75794f4b442bd1a8ed397c32e08c095af84d06e"
    sha256 cellar: :any,                 big_sur:        "568e88a0a4fe77c9e755b9c30a6b82b0cd512de524d0b05ed08c5a17e61086b6"
    sha256 cellar: :any,                 catalina:       "809940a30ef32ac717bd1d53323faa5961397450c21da4f89d7dc4584eb50f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f76ff2d9da4f73f08d609002fafe2480ab64d1e4b62ea2473e208df4ca575c3"
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
