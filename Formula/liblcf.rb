class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/liblcf-0.6.2.tar.xz"
  sha256 "c48b4f29ee0c115339a6886fc435b54f17799c97ae134432201e994b1d3e0d34"
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "ad47f77bf4aeec9e217ca99dc1a94111fa216f8be78274befb165c6f5de5ff93" => :catalina
    sha256 "9e61074ba9d58918164e5cda9c8d66274606609ef749326955240e598d8bbb80" => :mojave
    sha256 "536503d61c79bb93f47712da0eae7917f79def7d7e2565ae243c1b8fd1f643a4" => :high_sierra
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
