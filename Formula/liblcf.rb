class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/liblcf-0.6.2.tar.xz"
  sha256 "c48b4f29ee0c115339a6886fc435b54f17799c97ae134432201e994b1d3e0d34"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "2e9d41df9271f2aff0121b88f1d2fa4257a0c4dd3baeb5ee516e90ae67c884eb" => :catalina
    sha256 "f4518edc8ebea5c1022e505e57dee8d0f9e2be481108171089e069867e2e5139" => :mojave
    sha256 "ee900d1f90e33cd831a1e8e215813cd31daa8d6e90d08423bb78484f5176728d" => :high_sierra
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
