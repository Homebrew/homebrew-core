class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.4.tar.gz"
  sha256 "fb31eebfa0e9a06cae9bfdc77c295f5deeaf44ab4d688da4a78777c77df125e6"
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "0d2b6a270ae79194597674af96acd7f900da9b561bdc2e78680a7c6e23f59367" => :mojave
    sha256 "86ce78f1757ffa349ed43dc19518b4d8bbccb994e494b37bd3c8f0a395aa211e" => :high_sierra
    sha256 "e630bdd83ca7e7fc5321ff1accc4fd2dd3942b18d8131753d88e5988dc01b181" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "icu4c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
