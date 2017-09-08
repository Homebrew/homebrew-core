class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.42.1/ivykis-0.42.1.tar.gz"
  sha256 "1872a42cc9f07e414ad3c81638c567fba1458fdf274b3522aa82dfd8af632031"

  bottle do
    cellar :any
    sha256 "d00e2f4249be94f9cfd82aa1027dc1593f43f588daba8a6f94e7fd4a78cfff72" => :sierra
    sha256 "1aeebe50e35b36b1e86d99eee2e5590b0a0a0819f602b2d81ca49b8869b697ab" => :el_capitan
    sha256 "218ce5ca37379bd40f1ff45894c0f5cd32395833cc034b443c2ef1bea4e06802" => :yosemite
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
