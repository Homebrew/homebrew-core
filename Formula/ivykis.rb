class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.42.2/ivykis-0.42.2.tar.gz"
  sha256 "886b260369be22e438f7917ed2bc823d1cf4134bbfbc9339385a752247306b93"

  bottle do
    cellar :any
    sha256 "6de73482d7d358088ded2c8af43993710f2967c2e8c4cd8aa67a6600aefb35bd" => :high_sierra
    sha256 "3a9f5bdc6f40b4d7f9e7cdfcee7ad993cf02e2ac8fda0d20217ba6c10b783446" => :sierra
    sha256 "1f202587109188602e9da0e064ffbf08242726eba5fd51037638441ada78d3e1" => :el_capitan
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
    (testpath/"test_ivykis.c").write <<~EOS
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
