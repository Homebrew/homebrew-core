class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.9.0-src.tar.gz"
  sha256 "ed9ae6943a3520c7e14700692ebfbd568dad73790582efaeb4cab93104f21cfc"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "88a6a0062aa21324c449840d5304789a1feed2309bd9817d83114a0e54a22402" => :sierra
    sha256 "4a7393976890e0d00d1335410aff6c7dde6b820894262da2b7c27508c2287ee8" => :el_capitan
    sha256 "1530412b698806c01980dd29917aafcc14cb8dd223725d35e7d45672cbceabe6" => :yosemite
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
