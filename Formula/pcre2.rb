class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"
  revision 1

  # Remove `stable` block next release when patches are no longer needed
  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.38/pcre2-10.38.tar.bz2"
    sha256 "7d95aa7c8a7b0749bf03c4bd73626ab61dece7e3986b5a57f5ec39eebef6b07c"

    # fix incorrect detection of alternatives in first character search with JIT
    # remove in the next release
    patch do
      url "https://github.com/PhilipHazel/pcre2/commit/51ec2c9893e7dac762b70033b85f55801b01176c.patch?full_index=1"
      sha256 "0e91049d9d2afaff3169ddf8b0d95a9cd968793f2875af8064e0ab572c594007"
    end

    # enable JIT again in Apple Silicon with 11.2+ (sljit PR zherczeg/sljit#105)
    patch :p2 do
      url "https://github.com/zherczeg/sljit/commit/d6a0fa61e09266ad2e36d8ccd56f775e37b749e9.patch?full_index=1"
      sha256 "8d699f6c8ae085f50cf8823dcfadb8591f7ad8f9aa0db9666bd126bb625d7543"
      directory "src/sljit"
    end

    # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
    patch :p0, :DATA
  end

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "398a435ca747d30a60fce3a4df23a60925cddd997862b8225a7a3123e2209abd"
    sha256 cellar: :any,                 big_sur:       "c2f04108058a5cf4e9ad6ed127ea2b1195be6e13015241260683466cd49739d9"
    sha256 cellar: :any,                 catalina:      "1f81c9f906a96b87c922e4901e7f9f0057b259b82974737194f14f767bf437b0"
    sha256 cellar: :any,                 mojave:        "7eec2912f8a8248933a2c595185c4245b08f32f18b3a1a9dc84838a274aac16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502a9b9672c23b60b2a98db567171df17daf7851f8505f933c49b96699c3f64d"
  end

  head do
    url "https://github.com/PhilipHazel/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end

__END__
--- configure.orig	2021-10-01 08:15:08.000000000 -0700
+++ configure	2021-10-20 12:44:47.000000000 -0700
@@ -8733,16 +8733,11 @@
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
