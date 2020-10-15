class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/liblcf-0.6.2.tar.xz"
  sha256 "c48b4f29ee0c115339a6886fc435b54f17799c97ae134432201e994b1d3e0d34"
  license "MIT"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "1765ea5fd438e35c255104fcf3670f4fb20b44b0d88dfc5579deeb95fd0567a1" => :catalina
    sha256 "626aeacfaba89b8d5bb57945c4f82c33758e7a78de2b2d87261e6e83e874a7bc" => :mojave
    sha256 "b508d5fd894f0962328296f0d292eb3cd88e48d42d20e75934b7b9abad62c53a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  if MacOS.version < :el_capitan
    depends_on "expat"
  else
    uses_from_macos "expat"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
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
