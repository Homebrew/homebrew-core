class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.8.2-src.tar.gz"
  sha256 "e93a400df7514880135171ae105a412e76d76745ce9648647dfeea66c890b9c3"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "04f41bea33a688e7a195e4714b9c9bfec52437acf6b1452c9086e8eebe5b6851" => :sierra
    sha256 "1c5cce67fe72ed717b84b46c54150bde739233767e331add727ac7123a5bdeaa" => :el_capitan
    sha256 "31e0ed88ca2d1663318c4aefb3191c2e20e5aa9e15c6f71c9622fa0c81056893" => :yosemite
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
