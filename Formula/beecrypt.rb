class Beecrypt < Formula
  desc "C/C++ cryptography library"
  homepage "https://beecrypt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/beecrypt/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz"
  sha256 "286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3fcce19dcf6e9f7b864752d4a3a44864c774568203710fd7570684dec95c3f65"
    sha256 cellar: :any,                 arm64_monterey: "4acdd6c4d36e63cfdbcee335076ef3a2d037fabcda966692a02301bc3a1c59e1"
    sha256 cellar: :any,                 arm64_big_sur:  "c67f38d1f106232edf5db9ea96b28c9cc240805c3021a41279085e592b3d1a5e"
    sha256 cellar: :any,                 ventura:        "7657b38fa0f49bc9a8ecf87d84e6f7d6f3a2bee962632d43aea95da5207fe148"
    sha256 cellar: :any,                 monterey:       "76b490b3b3da57df7f5e13032c04ea577fddca473cc34d6274075c1100795ca4"
    sha256 cellar: :any,                 big_sur:        "6a5d3034c4818dbf4332a65bc677edb230d174b2c0f47a4c329960f97400f926"
    sha256 cellar: :any,                 catalina:       "977150a0ff6d0a8739539ad4865bcea9fe68d603d22b86d85d6fdef794d66611"
    sha256 cellar: :any,                 mojave:         "d4b8e542e1d0c6b805ced58ccf5342a29c29342631d0b180ef8b7268ca745d68"
    sha256 cellar: :any,                 high_sierra:    "75381fee700b8a6659dad5de0ea92df8d2e0bed0e1cd34755c8b3bfc39f99b89"
    sha256 cellar: :any,                 sierra:         "9bb192a3b891680eedbacb38cd9a2daa694cbef4d1db7b844d1809fb5504d660"
    sha256 cellar: :any,                 el_capitan:     "aafed63c6eb816d71151cf20830d76375ef872d2502babfe20f94683b3fcbf33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5940b480e169cfe86dc568bd7a6a527c569797fc7a99155931b0d75798118c7"
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
        sha256Update(&hash, string, 3);
        sha256Digest(&hash, digest);

        printf("%s\\n", crc = b64crc(digest, 32));

        free(crc);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbeecrypt", "-o", "test"
    assert_match "FJOO", shell_output("./test")
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
