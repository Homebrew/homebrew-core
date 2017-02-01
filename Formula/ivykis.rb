class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "http://libivykis.sourceforge.net"
  url "https://github.com/buytenh/ivykis/archive/v0.41.tar.gz"
  sha256 "b074441cc33aa0281f393c0a172136f0e0648266b89405b31ac819d64ea89e48"

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
    system ENV.cc, "test_ivykis.c", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
