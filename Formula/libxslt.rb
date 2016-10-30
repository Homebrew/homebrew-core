class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.29.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxslt-1.1.29.tar.gz"
  sha256 "b5976e3857837e7617b29f2249ebb5eeac34e249208d31f1fbf7a6ba7a4090ce"

  bottle do
    sha256 "1723ec2f62678ee51231605fd6a38f392312f80f4c2754da2763870bccb032ab" => :sierra
    sha256 "b77dfef558e110a710cae786918e1be56ffa6815c1f7f241f5d69e31a2ca5a24" => :el_capitan
    sha256 "353119ea7d1be30141944cf716b76df941e7f776209c15217607cbced8ca5f14" => :yosemite
    sha256 "03aecde25d5312258ba0d752f7fb04573b6be93ab784ef41a555de15af333541" => :mavericks
  end

  head do
    url "https://git.gnome.org/browse/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # https://bugzilla.gnome.org/show_bug.cgi?id=743148
    patch :DATA
  end

  keg_only :provided_by_osx

  depends_on "libxml2"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    # https://bugzilla.gnome.org/show_bug.cgi?id=762967
    inreplace "configure", /PYTHON_LIBS=.*/, 'PYTHON_LIBS="-undefined dynamic_lookup"'

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index 0eeadd3..5e85821 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -8,7 +8,7 @@ THEDIR=`pwd`
 cd $srcdir
 DIE=0
 
-(autoconf --version) < /dev/null > /dev/null 2>&1 || {
+(autoreconf --version) < /dev/null > /dev/null 2>&1 || {
 	echo
 	echo "You must have autoconf installed to compile libxslt."
 	echo "Download the appropriate package for your distribution,"
@@ -16,22 +16,6 @@ DIE=0
 	DIE=1
 }
 
-(libtoolize --version) < /dev/null > /dev/null 2>&1 || {
-	echo
-	echo "You must have libtool installed to compile libxslt."
-	echo "Download the appropriate package for your distribution,"
-	echo "or see http://www.gnu.org/software/libtool"
-	DIE=1
-}
-
-(automake --version) < /dev/null > /dev/null 2>&1 || {
-	echo
-	DIE=1
-	echo "You must have automake installed to compile libxslt."
-	echo "Download the appropriate package for your distribution,"
-	echo "or see http://www.gnu.org/software/automake"
-}
-
 if test "$DIE" -eq 1; then
 	exit 1
 fi
@@ -46,14 +30,7 @@ if test -z "$NOCONFIGURE" -a -z "$*"; then
 	echo "to pass any to it, please specify them on the $0 command line."
 fi
 
-echo "Running libtoolize..."
-libtoolize --copy --force
-echo "Running aclocal..."
-aclocal $ACLOCAL_FLAGS
-echo "Running automake..."
-automake --add-missing --warnings=all
-echo "Running autoconf..."
-autoconf --warnings=all
+autoreconf -v --force --install -Wall
 
 cd $THEDIR
 
