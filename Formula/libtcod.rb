class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://bitbucket.org/libtcod/libtcod/get/1.8.2.tar.bz2"
  sha256 "a33aa463e78b6df327d2aceae875edad8dba7a9e5ea0f1299c486b99f4bed31c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4ed64942b836e3bbfe50fa3eb97eeb66acd4d0d1aa7fe253126c2b5b6353d6c8" => :mojave
    sha256 "961e7dee0e97894c62d382e6ab2454d14cb77a7a3d20ead0fbd965b825957ca4" => :high_sierra
    sha256 "cf96ee73d811071c9ee411e884d9cd8276f1dcbbd121d9d42284ead55a1dcb6b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  conflicts_with "libzip", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    cd "build/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    include.install Dir["include/*"]
    # don't yet know what this is for
    libexec.install "data"
  end
end
