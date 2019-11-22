class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://github.com/buytenh/ivykis/archive/v0.42.4-trunk.tar.gz"
  version "0.42.4"
  sha256 "b724516d6734f4d5c5f86ad80bde8fc7213c5a70ce2d46b9a2d86e8d150402b5"

  bottle do
    cellar :any
    sha256 "568b30d892de7733ef401b8103325cc19d671379b8f970e5e9a8f49463100c3a" => :catalina
    sha256 "4e33d0afd4c85a7dda64e0ceef937572c97beb5cbf3ddc54491eaa312f390e7b" => :mojave
    sha256 "fb7ee29809095d025bb9c34b73c5a9922a03ca631af52e790e14332be284c5ad" => :high_sierra
    sha256 "2e9a9353e50a5cf3cc84a663d575e12a30d0d623212718e86dea0cec647496d7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
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
