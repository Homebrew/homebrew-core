class Libdv < Formula
  desc "Codec for DV video encoding format"
  homepage "https://libdv.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libdv/libdv/1.0.0/libdv-1.0.0.tar.gz"
  sha256 "a305734033a9c25541a59e8dd1c254409953269ea7c710c39e540bd8853389ba"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "c14359502e9d8c606b0424966181a93c26fec27eb9ca41f2313af62888716c4d"
    sha256 cellar: :any,                 arm64_sequoia:  "d9ec199c7cbb78a2e15ba681e90f94cb34e7c4e4d4856ebe85553661847a4f3b"
    sha256 cellar: :any,                 arm64_sonoma:   "b3e7be7a0887586ce1373382cdd83d7537b273fc622cf606ea3e1d425461b594"
    sha256 cellar: :any,                 arm64_ventura:  "e7c73ec9982ec05267073663395ff00a2a5eb7927a0df172441890d402e11077"
    sha256 cellar: :any,                 arm64_monterey: "58a4f24c622c38ba33f3c2972dff249e77b891d68e06553a99a71dc42801f08e"
    sha256 cellar: :any,                 arm64_big_sur:  "a72d9919c11d6950fcd115e6fa0e6cbac86ec6f06d8ade46b642006f652bf53f"
    sha256 cellar: :any,                 sonoma:         "d67945be1d2aba728715b9f67f68bd91fab88599bb351a179bfa89829bb5ac19"
    sha256 cellar: :any,                 ventura:        "e9109a663d65ae5085c53d011421cc9cb09821fd42b8002c0d2d241db7ebc180"
    sha256 cellar: :any,                 monterey:       "95529c6172e3054e8cf7057d6a0da13d20a8f368a4828a4103f5b1f37136b340"
    sha256 cellar: :any,                 big_sur:        "81db616fc05c65d944af1a500e9d647764e361419040b0007d9efc85ebfe3d31"
    sha256 cellar: :any,                 catalina:       "ee4a56e9a1462b87632dca0048808d4918b5a72fd943cce8ee600d138c9f67f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a7be333d02ace53395d0dcaad23163a9bf3a159aa05cc71a7202ee8eb917adf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e579189286f35409557243fe450e7509536f831777f37ae2f7519913bddcf8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "popt"

  # remove SDL1 dependency by force
  patch :DATA

  def install
    # This fixes an undefined symbol error on compile.
    # See the port file for libdv:
    #   https://trac.macports.org/browser/trunk/dports/multimedia/libdv/Portfile
    # This flag is the preferred method over what macports uses.
    # See the apple docs: https://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
    ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-asm",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-sdltest",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dubdv", "--version"
    system bin/"dvconnect", "--version"
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
