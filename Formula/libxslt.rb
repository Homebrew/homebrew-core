class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz"
  sha256 "526ecd0abaf4a7789041622c3950c0e7f2c4c8835471515fd77eec684a355460"

  bottle do
    sha256 "9ec247ef3cb3dcb30a5f2392150ef3323e49c5270d959cec3ffb008c2192ad52" => :mojave
    sha256 "502430d08fb7c8d0462ca5421b66caee4d9b8e39f3c7460c2bfca91be37091f9" => :high_sierra
    sha256 "5d68588f3afbdd93022aeaf81b9c6403c0c6b8aac24e5ba25a195c5ec5bad7e5" => :sierra
    sha256 "66854da0ffbb83f60863c23b985e5522037db4957aca70e2b49346a243a30991" => :el_capitan
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # https://bugzilla.gnome.org/show_bug.cgi?id=743148
    patch :DATA
  end

  keg_only :provided_by_macos

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

  def caveats; <<~EOS
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
 
