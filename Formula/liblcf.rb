class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.2.tar.gz"
  sha256 "acd0bdb55a9713150fb4d68176e8f5459c5554e23d4af60c60fb1ff5f17598b0"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "0d0c68c97c2d2131637b75770718046b6262a520cc9c65e95f9e0c14a53a9e9f" => :sierra
    sha256 "6726003d6957b5e6ff8f4cbe78bf3d3b2cba3b6f935dc7a8f1397ab2c5915a76" => :el_capitan
    sha256 "2712ab5f38846fa59885b48c365cf00fe3e7cb70d72b67498eba25c2a4502c5f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "expat"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "lsd_reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == LSD_Reader::ToUnixTimestamp(LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/liblcf", "-L#{lib}", "-llcf", "-std=c++11", \
      "-o", "test"
    system "./test"
  end
end
