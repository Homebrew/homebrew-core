class Beecrypt < Formula
  desc "C/C++ cryptography library"
  homepage "https://beecrypt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/beecrypt/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz"
  sha256 "286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d"
  revision 7

  bottle do
    cellar :any
    sha256 "977150a0ff6d0a8739539ad4865bcea9fe68d603d22b86d85d6fdef794d66611" => :catalina
    sha256 "d4b8e542e1d0c6b805ced58ccf5342a29c29342631d0b180ef8b7268ca745d68" => :mojave
    sha256 "75381fee700b8a6659dad5de0ea92df8d2e0bed0e1cd34755c8b3bfc39f99b89" => :high_sierra
    sha256 "9bb192a3b891680eedbacb38cd9a2daa694cbef4d1db7b844d1809fb5504d660" => :sierra
    sha256 "aafed63c6eb816d71151cf20830d76375ef872d2502babfe20f94683b3fcbf33" => :el_capitan
    sha256 "c321c1ab92e2f644460e3f2cba59495962735a3b046744692a171deebffba29b" => :yosemite
  end

  depends_on "libtool" => :build

  # fix build with newer clang, gcc 4.7 (https://bugs.gentoo.org/show_bug.cgi?id=413951)
  patch :p0, :DATA

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-openmp",
                          "--without-java",
                          "--without-python"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "beecrypt/base64.h"
      #include "beecrypt/sha256.h"
      #include <stdio.h>

      int main(void)
      {
        sha256Param hash;
        const byte *string = (byte *) "abc";
        byte digest[32];
        byte *crc;

        sha256Reset(&hash);
        sha256Update(&hash, string, sizeof(string) / sizeof(*string));
        sha256Process(&hash);
        sha256Digest(&hash, digest);

        printf("%s\\n", crc = b64crc(digest, 32));

        free(crc);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbeecrypt", "-o", "test"
    assert_match /ZF8D/, shell_output("./test")
  end
end

__END__
--- include/beecrypt/c++/util/AbstractSet.h~	2009-06-17 13:05:55.000000000 +0200
+++ include/beecrypt/c++/util/AbstractSet.h	2012-06-03 17:45:55.229399461 +0200
@@ -56,7 +56,7 @@
 					if (c->size() != size())
 						return false;
 
-					return containsAll(*c);
+					return this->containsAll(*c);
 				}
 				return false;
 			}
