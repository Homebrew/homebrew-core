class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.13.3/freetype-2.13.3.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.3.tar.xz"
  sha256 "0550350666d427c74daeb85d5ac7bb353acba5f76956395995311a9c6f063289"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bcd39d3a523690cb0673df46122ff62763c5cd93bfff21bdcab856501d2dfb49"
    sha256 cellar: :any,                 arm64_sonoma:   "939f90de3dd92919020832ba03d6617a0d2ec9a8e185f6a2c518f149c7b299f4"
    sha256 cellar: :any,                 arm64_ventura:  "47122c7d025f841f3816f1bc2c14ad1e6b4227ccc56eae2827fa585d3b58dbc5"
    sha256 cellar: :any,                 arm64_monterey: "ace9a5d707a94eb85c67fe349e48c9264287c2d80e0ce60f9bfe5772be2983f4"
    sha256 cellar: :any,                 sonoma:         "e79e0ffb36311b2abbd0cd44abcf5e938768b2d63d6268e68d5eaa4d34d9323e"
    sha256 cellar: :any,                 ventura:        "495efbb088b72c7a2881133bcd53375dd99925124d2bf1f0e0882a3c1a332b10"
    sha256 cellar: :any,                 monterey:       "eb6099180cefba47b4e31f9680494fa8a1a60e50f190232b281f6beed53874a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b5d9d793c5dc7b6a1187e1266a133a39854d2ac32e77c2d1baab90882006fdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d847168ffbda85c4470d7599436263b0fd8623687863e26ee434db56cd5dde9"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
