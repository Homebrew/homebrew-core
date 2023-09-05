class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  license "AGPL-3.0-or-later"

  stable do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10012/ghostpdl-10.01.2.tar.xz"
    sha256 "b535600c968f672b4f6750e7eac57623fc7f80eb8c00a0175a46010942cf0e9c"

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
    sha256 arm64_ventura:  "290522bb038d5db01e9cd834274e196400c37bdfb2c1ba8ed8a82816650c70b1"
    sha256 arm64_monterey: "f9ead5cafe7569cc3b34c4d8c228700edb0cf3d3f58506e25c1299fe0eb47612"
    sha256 arm64_big_sur:  "1dc38aea6fd4bc9c9e5b6d6465459384d8b1a2025a0d1a1997c01b920b8f1667"
    sha256 ventura:        "2ebfb45d30096d1c6ddf5842f7217a80f0f7cd1709fabbc0658a012a3120a71f"
    sha256 monterey:       "6df60d383c7b1560ccd1e55e9ec2800c9bc565e704ed112feba29efc908d21ac"
    sha256 big_sur:        "a52592ba7398d8ddd6d9e174c5547b282294bcf5fe15d6685e97428be13d46d1"
    sha256 x86_64_linux:   "68d6d77c2776b7c64aacb6a0c0f4e6ef838090c831f0f8a6ec91f60c2792a28e"
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

  conflicts_with "gambit-scheme", because: "both install `gsc` binary"

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
