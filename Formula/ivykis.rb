class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.42.2/ivykis-0.42.2.tar.gz"
  sha256 "886b260369be22e438f7917ed2bc823d1cf4134bbfbc9339385a752247306b93"

  bottle do
    cellar :any
    sha256 "62a8dbb5c60584e4d9138779c83775db72d9fb8de81afa261e0a18c57e88cbae" => :high_sierra
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
