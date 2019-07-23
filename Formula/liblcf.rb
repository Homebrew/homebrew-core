class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.6.1.tar.gz"
  sha256 "224068ede007098d8fad45348da3b47f00a33d5e8a4a693514d5c9290ab1883f"
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "6a26a0c35abe32d585c08350b20308984fa920013d9549715b6bdc9cea7d4276" => :mojave
    sha256 "9b955bdce9148eadfa65b0ba5503aa1bc7243b7be7ad0b08303749238060e0aa" => :high_sierra
    sha256 "f66182cd8b1b4f3de29547dc0c5cb729d85be6beeefdd8c18f324eb547d527fe" => :sierra
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
