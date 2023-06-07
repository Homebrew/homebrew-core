class Libdv < Formula
  desc "Codec for DV video encoding format"
  homepage "https://libdv.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libdv/libdv/1.0.0/libdv-1.0.0.tar.gz"
  sha256 "a305734033a9c25541a59e8dd1c254409953269ea7c710c39e540bd8853389ba"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e7c73ec9982ec05267073663395ff00a2a5eb7927a0df172441890d402e11077"
    sha256 cellar: :any,                 arm64_monterey: "58a4f24c622c38ba33f3c2972dff249e77b891d68e06553a99a71dc42801f08e"
    sha256 cellar: :any,                 arm64_big_sur:  "a72d9919c11d6950fcd115e6fa0e6cbac86ec6f06d8ade46b642006f652bf53f"
    sha256 cellar: :any,                 ventura:        "e9109a663d65ae5085c53d011421cc9cb09821fd42b8002c0d2d241db7ebc180"
    sha256 cellar: :any,                 monterey:       "95529c6172e3054e8cf7057d6a0da13d20a8f368a4828a4103f5b1f37136b340"
    sha256 cellar: :any,                 big_sur:        "81db616fc05c65d944af1a500e9d647764e361419040b0007d9efc85ebfe3d31"
    sha256 cellar: :any,                 catalina:       "ee4a56e9a1462b87632dca0048808d4918b5a72fd943cce8ee600d138c9f67f6"
    sha256 cellar: :any,                 mojave:         "ec2564e27b321ebb35a3278d6e7411d17d1b1acad5dbcd40106cbcaf24205b53"
    sha256 cellar: :any,                 high_sierra:    "0f7c7db1baa95682ad66b9d628d51978f162558f6d8296715a38150f83a7c72f"
    sha256 cellar: :any,                 sierra:         "9ea1a006d7aa954c5a1d61497f9f7f43e0b1bd5bce911b6d334a693d8af58671"
    sha256 cellar: :any,                 el_capitan:     "0624e82748111d0a8a050a802ec4251c443127c39c93b3b2469a00816a602040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e579189286f35409557243fe450e7509536f831777f37ae2f7519913bddcf8"
  end

  depends_on "popt"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  # remove SDL1 dependency by force
  patch :DATA

  def install
    if OS.mac?
      # This fixes an undefined symbol error on compile.
      # See the port file for libdv:
      #   https://trac.macports.org/browser/trunk/dports/multimedia/libdv/Portfile
      # This flag is the preferred method over what macports uses.
      # See the apple docs: https://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"
      system "autoreconf", "-fvi"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-asm",
                          "--disable-sdltest"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 2b95735..1ba9370 100644
--- a/configure.ac
+++ b/configure.ac
@@ -173,13 +173,6 @@ dnl used in Makefile.am
 AC_SUBST(GTK_CFLAGS)
 AC_SUBST(GTK_LIBS)
 
-if $use_sdl; then
-	AM_PATH_SDL(1.1.6,
-	[
-		AC_DEFINE(HAVE_SDL) 
- 	])
-fi
-
 if [ $use_gtk && $use_xv ]; then
 	AC_CHECK_LIB(Xv, XvQueryAdaptors,
 		[AC_DEFINE(HAVE_LIBXV)
