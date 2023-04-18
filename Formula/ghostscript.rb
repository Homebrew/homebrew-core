class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  license "AGPL-3.0-or-later"

  stable do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10011/ghostpdl-10.01.1.tar.xz"
    sha256 "e6a6c39a36e6b6ffe4960f4e2bfb85420ed157ac14a202ccdd0df4e4e2a7e392"

    on_macos do
      # 1. Make sure shared libraries follow platform naming conventions.
      # 2. Prevent dependent rebuilds on minor version bumps.
      # Reported upstream at:
      #   https://bugs.ghostscript.com/show_bug.cgi?id=705907
      #   https://bugs.ghostscript.com/show_bug.cgi?id=705908
      patch :DATA
    end
  end

  # The GitHub tags omit delimiters (e.g. `gs9533` for version 9.53.3). The
  # `head` repository tags are formatted fine (e.g. `ghostpdl-9.53.3`) but a
  # version may be tagged before the release is available on GitHub, so we
  # check the version from the first-party website instead.
  livecheck do
    url "https://www.ghostscript.com/json/settings.json"
    regex(/["']GS_VER["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_ventura:  "2d9684b51e348763e405edf791bf70c097403488776c2a1a079373eeb077edb5"
    sha256 arm64_monterey: "e64fcb8d56b25cc386ff2cbb0b92ebfb1661038a361b7b82f0eb1bd4b5edb970"
    sha256 arm64_big_sur:  "20247a3d26276f0c05196e097cbe95eb48409a5c53f1b16f78185b74aeb47463"
    sha256 ventura:        "efff7911d701690da5712e1ec38029ed3e687158f2acd800018b4643896ed6d5"
    sha256 monterey:       "7411520f73b5f82a63ac6f3593e290a27d9702c6cb09802335eb987229377589"
    sha256 big_sur:        "c81130ce3d197fc63ae70db3b6730aa4b1a7bffb45387b4887d260280e7aed7e"
    sha256 x86_64_linux:   "0169f78042cd4088bd4c2f5a0e12b368f3cce8dcb44f733bf79eabc2bdadae2f"
  end

  head do
    url "https://git.ghostscript.com/ghostpdl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  # fmemopen is only supported from 10.13 onwards (https://news.ycombinator.com/item?id=25968777).
  # For earlier versions of MacOS, needs to be excluded.
  # This should be removed once patch added to next release of leptonica (which is incorporated by ghostscript in
  # tarballs).
  patch do
    url "https://github.com/DanBloomberg/leptonica/commit/848df62ff7ad06965dd77ac556da1b2878e5e575.patch?full_index=1"
    sha256 "7de1c4e596aad5c3d2628b309cea1e4fc1ff65e9c255fe64de1922b3fd2d60fc"
    directory "leptonica"
  end

  def install
    # Delete local vendored sources so build uses system dependencies
    libs = %w[expat freetype jbig2dec jpeg lcms2mt libpng openjpeg tiff zlib]
    libs.each { |l| (buildpath/l).rmtree }

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-compile-inits",
                      "--disable-cups",
                      "--disable-gtk",
                      "--with-system-libtiff",
                      "--without-x"

    # Install binaries and libraries
    system "make", "install"
    ENV.deparallelize { system "make", "install-so" }

    (pkgshare/"fonts").install resource("fonts")
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match "Hello World!", shell_output("#{bin}/ps2ascii #{ps}")
  end
end

__END__
diff --git a/base/unix-dll.mak b/base/unix-dll.mak
index 89dfa5a..c907831 100644
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -100,10 +100,26 @@ GS_DLLEXT=$(DLL_EXT)
 
 
 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+PCL_SONAME=$(PCL_SONAME_BASE).$(GS_SOEXT)
+PCL_SONAME_MAJOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+PCL_SONAME_MAJOR_MINOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+XPS_SONAME=$(XPS_SONAME_BASE).$(GS_SOEXT)
+XPS_SONAME_MAJOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+XPS_SONAME_MAJOR_MINOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+PDF_SONAME=$(PDF_SONAME_BASE).$(GS_SOEXT)
+PDF_SONAME_MAJOR=$(PDF_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+PDF_SONAME_MAJOR_MINOR=$(PDF_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+GPDL_SONAME=$(GPDL_SONAME_BASE).$(GS_SOEXT)
+GPDL_SONAME_MAJOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GPDL_SONAME_MAJOR_MINOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
 #LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)
diff --git a/configure b/configure
index bfa0985..8de469c 100755
--- a/configure
+++ b/configure
@@ -12805,11 +12805,11 @@ case $host in
     ;;
     *-darwin*)
       DYNAMIC_CFLAGS="-fPIC $DYNAMIC_CFLAGS"
-      GS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GS_SONAME_MAJOR_MINOR)"
-      PCL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PCL_SONAME_MAJOR_MINOR)"
-      XPS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(XPS_SONAME_MAJOR_MINOR)"
-      PDL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GPDL_SONAME_MAJOR_MINOR)"
-      PDF_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PDF_SONAME_MAJOR_MINOR)"
+      GS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GS_SONAME_MAJOR)"
+      PCL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PCL_SONAME_MAJOR)"
+      XPS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(XPS_SONAME_MAJOR)"
+      PDL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GPDL_SONAME_MAJOR)"
+      PDF_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PDF_SONAME_MAJOR)"
       DYNAMIC_LIBS=""
       SO_LIB_EXT=".dylib"
     ;;
