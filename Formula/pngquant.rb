class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.9.1-src.tar.gz"
  sha256 "ac2138207ef40acd4e5fdae18798139a9d75dae4f1d0837aea918a2a8c433481"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "12a99cb2ebb120aa3a8a25772f3467f8d6f5922f49eb9e7173aaa87a34346b18" => :sierra
    sha256 "e57ca58f2c181b5cc741598ea7045e4bbed7223e98f547a5ec434e8e2c977057" => :el_capitan
    sha256 "1462b92b4b7dcce3bb9c3d862561719d1f1e5925af674eb8b417c870b2b5dda0" => :yosemite
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
