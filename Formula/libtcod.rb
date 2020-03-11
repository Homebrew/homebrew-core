class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6fab34197cacd706fb4b33c822d9827a2812201d8c1c662effcfb3779a48b83c" => :catalina
    sha256 "4ed64942b836e3bbfe50fa3eb97eeb66acd4d0d1aa7fe253126c2b5b6353d6c8" => :mojave
    sha256 "961e7dee0e97894c62d382e6ab2454d14cb77a7a3d20ead0fbd965b825957ca4" => :high_sierra
    sha256 "cf96ee73d811071c9ee411e884d9cd8276f1dcbbd121d9d42284ead55a1dcb6b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "sdl2"

  conflicts_with "libzip", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    cd "buildsys/autotools" do
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
