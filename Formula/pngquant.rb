class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.9.1-src.tar.gz"
  sha256 "ac2138207ef40acd4e5fdae18798139a9d75dae4f1d0837aea918a2a8c433481"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "28e9008636e272fef0020a0ce946ac1b96a825a6987f8624c0e412b618215288" => :sierra
    sha256 "b90f9caadbb3abf4a34cabf18408ac0bdab112e64c2a055a757bf25f023964ae" => :el_capitan
    sha256 "e0c3a662586e7b0e179018827a664b9cdb6eb4ca58dc459235b81c83863716cf" => :yosemite
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
