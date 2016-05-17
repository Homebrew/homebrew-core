class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  stable do
    url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.21.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.21.tar.bz2"
    sha256 "c66a17509328a7251782691093e75ede7484a203ebc6bed3c08122b092ccd4e0"
    # Patch from http://vcs.pcre.org/pcre2/code/trunk/src/pcre2_compile.c?view=patch&r1=489&r2=488&pathrev=489
    # Fixes CVE-2016-3191
    # Can be dropped once 10.22 is released
    patch :p2, :DATA
  end

  bottle do
    cellar :any
    sha256 "df6f0855251cd664b41896e72262d28ed73b82b585b09d5df1a8d54783c8583c" => :el_capitan
    sha256 "acd343182f0033d61a8b9266909a1c3a609d9a450d1cf28fe30fefa9c54c36e3" => :yosemite
    sha256 "febc1cf22e5da7f4f873dadda0d88a158602d99b49d61ed51441d82083a9b924" => :mavericks
    sha256 "5258f37a0149806a78d777c6c311ff9c53eff4d4ae3d14c47825f4c279eed298" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pcre2grep", "regular expression", "#{prefix}/README"
  end
end
__END__
--- code/trunk/src/pcre2_compile.c	2016/02/06 16:40:59	488
+++ code/trunk/src/pcre2_compile.c	2016/02/10 18:24:02	489
@@ -5901,10 +5901,22 @@
               goto FAILED;
               }
             cb->had_accept = TRUE;
+            
+            /* In the first pass, just accumulate the length required;
+            otherwise hitting (*ACCEPT) inside many nested parentheses can
+            cause workspace overflow. */
+              
             for (oc = cb->open_caps; oc != NULL; oc = oc->next)
               {
-              *code++ = OP_CLOSE;
-              PUT2INC(code, 0, oc->number);
+              if (lengthptr != NULL)
+                {
+                *lengthptr += CU2BYTES(1) + IMM2_SIZE; 
+                }
+              else
+                {       
+                *code++ = OP_CLOSE;
+                PUT2INC(code, 0, oc->number);
+                } 
               }
             setverb = *code++ =
               (cb->assert_depth > 0)? OP_ASSERT_ACCEPT : OP_ACCEPT;
