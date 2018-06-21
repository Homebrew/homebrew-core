class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.3.tar.gz"
  sha256 "4d2784ab927e2f61595b8efeb61664bcc64b3f746d12c893e302645dda3acddc"
  revision 4
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "0b530dcdbbbd23975ef4fe86e9f33192f6b3cb2ac0a29303c9cbbaad7e7ee09c" => :high_sierra
    sha256 "c8c0870f7cbef63001ddbe1ed262ab152032170299e0e63c1d5db930c12a0793" => :sierra
    sha256 "24060913cbc1abeba13c619272e7a16b851f31fb4448cc08b5d5d98c389d5e42" => :el_capitan
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
