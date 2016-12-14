class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftpmirror.gnu.org/cpio/cpio-2.11.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/cpio/cpio-2.11.tar.bz2"
  sha256 "bb820bfd96e74fc6ce43104f06fe733178517e7f5d1cdee553773e8eff7d5bbd"
  # tag "linuxbrew"

  # Fix the error:
  # ./stdio.h:358:1: error: 'gets' undeclared here (not in a function)
  # _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
  patch :DATA

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cpio", "--version"
  end
end

__END__
--- a/gnu/stdio.in.h  2010-03-10 09:27:03.000000000 +0000
+++ b/gnu/stdio.in.h  2014-11-08 16:56:30.000000000 +0000
@@ -139,7 +139,9 @@
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
 #undef gets
+#ifdef HAVE_RAW_DECL_GETS
 _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
+#endif
 
 #if @GNULIB_FOPEN@
 # if @REPLACE_FOPEN@
