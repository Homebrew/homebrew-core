class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.3.tar.gz"
  sha256 "4d2784ab927e2f61595b8efeb61664bcc64b3f746d12c893e302645dda3acddc"
  revision 2
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "8b00ff7a74d58d6f315ed22fdb5b9a799cbec3f1c75ea35ee2134f3d7d5ad2bf" => :high_sierra
    sha256 "1c1514ecf27ea169f6838e88a1ad79a2128cc6bbd48411b66cca0a8fa7d8dbb4" => :sierra
    sha256 "06f9de2baf0ca8eb1cd18b213a7a51b908c1e4c477510aa2bcc8a1d6357177bf" => :el_capitan
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
