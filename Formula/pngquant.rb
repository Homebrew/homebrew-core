class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.8.0-src.tar.gz"
  sha256 "685f5a007582abbe7735f09b12c0202cb091ede935dbc5199c8b27e0a90346d6"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "1b0836b2909a518e500105cb88059c42d0a35bed3c3a3ba07275394af83487cd" => :sierra
    sha256 "4f48d41c37123595c72cdd720bb318eb7dd84b6fc574a987d2cab0c76d9252c8" => :el_capitan
    sha256 "6c1ddc229899bb590eb87f21a8833871da2e37b37552f18c78c6cb557e5e7043" => :yosemite
    sha256 "ff4035cd4368e7b17491e60b0c14c26cfc72860d376fe863d8ac5b436ed59a1e" => :mavericks
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
