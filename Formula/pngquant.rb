class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.8.0-src.tar.gz"
  sha256 "685f5a007582abbe7735f09b12c0202cb091ede935dbc5199c8b27e0a90346d6"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "1e625bc508681a0b9ffc489079e3fd096b18e496192a1a0d063d4ee129885100" => :sierra
    sha256 "5c7989802e432adbffd0fb3bb0dd170ee93df6537684b88e7350b050d795af98" => :el_capitan
    sha256 "2707b7ef3d533d771f520242feaa158f27cbc1190d0480b41590996937726551" => :yosemite
  end

  option "with-openmp", "Enable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "little-cms2" => :optional

  needs :openmp if build.with? "openmp"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug

    args = ["--prefix=#{prefix}"]
    args << "--with-lcms2" if build.with? "little-cms2"

    if build.with? "openmp"
      args << "--with-openmp"
      args << "--without-cocoa"
    end

    system "./configure", *args
    system "make", "install", "CC=#{ENV.cc}"

    man1.install "pngquant.1"
    lib.install "lib/libimagequant.a"
    include.install "lib/libimagequant.h"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    File.exist? testpath/"out.png"
  end
end
