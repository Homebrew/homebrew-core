class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.41/ivykis-0.41.tar.gz"
  sha256 "2c934539a59029851b1332c8143ba9f21b79fb0185dd68d6eb259ae1b61ef3c5"

  bottle do
    cellar :any
    sha256 "8aa737754faeda65a8f369f85d89822d78f5285e131eaba4d3fe57c578f57051" => :sierra
    sha256 "1914551ff67e301b8700e51a6e93096de43c793c19603b09302fff5d4e74ef0b" => :el_capitan
    sha256 "b5b60d80ac9f9c1891d3f965b4d963b427497e0127cb6ca7892bb71943f0709e" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<-EOS.undent
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
