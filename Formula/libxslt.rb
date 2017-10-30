class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.31.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxslt-1.1.31.tar.gz"
  sha256 "db25e96b6b801144277e67c05b10560ac09dfff82ccd53a154ce86e43622f3ab"

  bottle do
    sha256 "ca78df75fec0ffdee11a6407d48483eb5b5935d373dafd8917d1bfeda3b571dc" => :high_sierra
    sha256 "919d829abb0e9e580e1f79275891d47f6e5a8c9c0262c9d8076c6dacaf41377a" => :sierra
    sha256 "60ab15572aa6cd85cd82c272cb56f188b71ea754611191cb4763cac003b18e9c" => :el_capitan
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
 
