class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.2.tar.gz"
  sha256 "acd0bdb55a9713150fb4d68176e8f5459c5554e23d4af60c60fb1ff5f17598b0"
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "f4fc2587c5a4a78dc5fefcf977934bcad7a8c6a0244d9e0e238aaa159f454ff4" => :sierra
    sha256 "2ed8b08aa4d416cf7f913cdd1bf2f2c3425c76ffd3f558b05bf604fcd6335d85" => :el_capitan
    sha256 "2b2cacec709a44e02329f97a0ef71a374a8cc07ca0a51288ae225f5e5034190a" => :yosemite
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
