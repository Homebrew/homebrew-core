class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/108/gwenhywfar-4.20.2.tar.gz"
  sha256 "0f4fd92351c8a11f053aa482fc5c459499db3dc78dd8bb469e878890ef3d3270"

  bottle do
    sha256 "43fbdfc140f948cac62e00c6468b310856797b3bd732e8e7db2dee4983ec2787" => :mojave
    sha256 "b14e191f6863b0bd133367cd1e5e22a0785550edbf3637930b5d16ec2a83ecd9" => :high_sierra
    sha256 "a006e0b29c726b480bcdcfc40192d776c7ce2e8e44196122d7aabf3884857c5f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
