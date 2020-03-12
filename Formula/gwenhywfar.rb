class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/256/gwenhywfar-5.2.0.tar.gz"
  sha256 "ed8e1f81aa32c8c387cccb9d40390db31632be55bc41bd30bc27e3e45d4d2766"

  bottle do
    sha256 "ec5063e1ac5176d5b43f03adea1cc550f98a74ad2148fd18aff41db918ebdb17" => :catalina
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
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
