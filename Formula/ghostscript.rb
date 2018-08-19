class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23.tar.xz"
  sha256 "1fcedc27d4d6081105cdf35606cb3f809523423a6cf9e3c23cead3525d6ae8d9"

  bottle do
    sha256 "61cd3ed2bde23ff760b16c83607a452016dc0c9b377c544d6a646fa853fbcec9" => :mojave
    sha256 "dc2e6603867294e34d8f7910e436c096227c8b791ae886c7acc3a5c2fb03dc91" => :high_sierra
    sha256 "f08fd9db80054129d5b2abc8528f74afbb89bb658ad4ed39daf38908b6957173" => :sierra
    sha256 "d0ddb0ab33db756543f7616b9a3558f43527784495df0ae7e717c2b0daa738ec" => :el_capitan
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
      --disable-fontconfig
      --without-libidn
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

