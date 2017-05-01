class Libconfini < Formula
  desc "Yet another INI parser"
  homepage "https://github.com/madmurphy/libconfini"
  url "https://github.com/madmurphy/libconfini/archive/1.3-4.tar.gz"
  version "1.3-4"
  sha256 "db2ee05b5974b3df22e1afc37da65b78506b8216c85594232ee7dec56d8a20f8"

  patch :DATA

  depends_on "gettext" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "intltool" => :build
  depends_on "glib" => :build

  def install
    system "sh", "autogen.sh",
                 "--disable-dependency-tracking",
                 "--disable-silent-rules",
                 "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.conf").write <<-EOS.undent
      [section]
      foo = bar
    EOS
    (testpath/"test.c").write <<-EOS.undent
      #include <confini.h>
      #include <stdio.h>
      
      int main() {
        if(load_ini_file("test.conf", INI_DEFAULT_FORMAT, NULL, NULL, NULL))
          return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lconfini", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index a0ec5ee..18b1018 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -49,7 +49,7 @@ fi
 }
 
 (grep "^LT_INIT" $srcdir/configure.ac >/dev/null) && {
-  (libtool --version) < /dev/null > /dev/null 2>&1 || {
+  (glibtool --version) < /dev/null > /dev/null 2>&1 || {
     echo
     echo "**Error**: You must have \`libtool' installed."
     echo "You can get it from: ftp://ftp.gnu.org/pub/gnu/"
@@ -131,7 +131,7 @@ do
       if grep "^LT_INIT" configure.ac >/dev/null; then
 	if test -z "$NO_LIBTOOLIZE" ; then 
 	  echo "Running libtoolize..."
-	  libtoolize --force --copy
+	  glibtoolize --force --copy
 	fi
       fi
       echo "Running aclocal $aclocalinclude ..."
