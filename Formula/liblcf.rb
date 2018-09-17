class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.3.tar.gz"
  sha256 "4d2784ab927e2f61595b8efeb61664bcc64b3f746d12c893e302645dda3acddc"
  revision 4
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "cfd281ca0ad6bca4909e79484fef6762668675bc5974c91939cb7487486d7a48" => :mojave
    sha256 "8f236c85cb7f32be1b00bed909f8c9db4cd06496d5a6c9d84c59b14d83d4c9c1" => :high_sierra
    sha256 "2ed31b9968f0032deee9505b24b6aec5a17b1657ed42de1f5cf3d039f15f7a28" => :sierra
    sha256 "a2a167e689d70167f40578d57168cfac660d83f3054705bc1dae20bb85f1f863" => :el_capitan
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
