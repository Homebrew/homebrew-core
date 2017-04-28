class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  revision 1

  stable do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs921/ghostscript-9.21.tar.xz"
    sha256 "2be1d014888a34187ad4bbec19ab5692cc943bd1cb14886065aeb43a3393d053"

    # Remove for > 9.21
    # First part of fix for CVE-2017-8291
    # https://www.cve.mitre.org/cgi-bin/cvename.cgi?name=2017-8291
    # https://bugs.ghostscript.com/show_bug.cgi?id=697799
    # Upstream commit from 27 Apr 2017 "Bug 697799: have .eqproc check its parameters"
    patch do
      url "https://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=4f83478c88"
      sha256 "81f087fa6f3de81a83a4830a7b243b6da5506d783cf37ef1259cd600b1322e47"
    end

    # Remove for > 9.21
    # Second part of fix for CVE-2017-8291
    # Upstream commit from 27 Apr 2017 "Bug 697799: have .rsdparams check its parameters"
    patch do
      url "https://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=04b37bbce1"
      sha256 "366bf4ded600fc7b0a8e2b0d4c877cc3ad5a0ccc192cb660d81f729575a47259"
    end
  end

  bottle do
    sha256 "f4de879cfb6e4ef5e5c93dddeab48adf458c5a07a8804682498967fe9d359742" => :sierra
    sha256 "b8e066aece53c8e75f5883eac8617fde563733938029955a6cf07f7d8b4227c6" => :el_capitan
    sha256 "37b17208e6839ca273a73c5dd0f0a7e8f625f6d5aa816b74bd57de3375f94b00" => :yosemite
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "https://git.ghostscript.com/ghostpdl.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  patch :DATA # Uncomment macOS-specific make vars

  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on :x11 => :optional

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-cups
      --disable-compile-inits
      --disable-gtk
    ]
    args << "--without-x" if build.without? "x11"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    # Install binaries and libraries
    system "make", "install"
    system "make", "install-so"

    (pkgshare/"fonts").install resource("fonts")
    (man/"de").rmtree
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match /Hello World!/, shell_output("#{bin}/ps2ascii #{ps}")
  end
end

__END__
diff --git a/base/unix-dll.mak b/base/unix-dll.mak
index ae2d7d8..4f4daed 100644
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -64,12 +64,12 @@ GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE)$(GS_SOEXT)$(SO_LIB_VERSION_SEPARATOR)$(G
 
 
 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
-#LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
+LDFLAGS_SO_MAC=-dynamiclib -install_name __PREFIX__/lib/$(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)
 
 GS_SO=$(BINDIR)/$(GS_SONAME)

