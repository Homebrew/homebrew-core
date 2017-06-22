class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.10.tar.gz"
  sha256 "8a9b41be5bfcab5d8c1be74204b10ae78789fc3deabea0775fdced8677292639"

  bottle do
    sha256 "6139793b451fdb8d5310729a06286ed66b23aac02d0179bfd27b61df1cc9f931" => :sierra
    sha256 "cdad0b612a3236fed1b625be2bab6500e02578ba271552e6a8a19d2cdf12df2e" => :el_capitan
    sha256 "8e19891033bc8a96894692bf0a27898112d72de5bcc78e269ba505b75b17b64f" => :yosemite
    sha256 "ff3a53ac15b4baaf030f1f1556b24a7f69788175559660ac841e039d7aee996b" => :mavericks
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "gettext"

  deprecated_option "default-names" => "with-default-names"

  # Fix broken include and missing build dependency
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    system "#{bin}/gindent", "test.c"
    assert_equal File.read("test.c"), <<-EOS.undent
      int
      main ()
      {
        return 0;
      }
    EOS
  end
end

__END__
diff --git a/man/Makefile.in b/man/Makefile.in
index 76839bc..8a5fc6e 100644
--- a/man/Makefile.in
+++ b/man/Makefile.in
@@ -507,7 +507,7 @@ uninstall-man: uninstall-man1
 	uninstall-man uninstall-man1
 
 
-@PACKAGE@.1: ${srcdir}/@PACKAGE@.1.in  ${srcdir}/../doc/@PACKAGE@.texinfo texinfo2man.c  Makefile.am
+@PACKAGE@.1: ${srcdir}/@PACKAGE@.1.in  ${srcdir}/../doc/@PACKAGE@.texinfo texinfo2man.c  Makefile.am texinfo2man
 	./texinfo2man ${srcdir}/@PACKAGE@.1.in ${srcdir}/../doc/@PACKAGE@.texinfo > $@
 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
diff --git a/man/texinfo2man.c b/man/texinfo2man.c
index e7d82e1..c95266f 100644
--- a/man/texinfo2man.c
+++ b/man/texinfo2man.c
@@ -1,6 +1,5 @@
 #include <stdio.h>
 #include <stdlib.h>
-#include <malloc.h>
 #include <string.h>
 #include <ctype.h>
 
