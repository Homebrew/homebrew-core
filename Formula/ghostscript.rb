class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  revision 1

  stable do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23.tar.xz"
    sha256 "1fcedc27d4d6081105cdf35606cb3f809523423a6cf9e3c23cead3525d6ae8d9"

    # https://bugs.chromium.org/p/project-zero/issues/detail?id=1640
    # https://www.kb.cert.org/vuls/id/332928
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/ghostscript/ghostscript_9.22~dfsg-3.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/ghostscript/ghostscript_9.22~dfsg-3.debian.tar.xz"
      sha256 "1dfce2417808cf299ce9d6cb07751ae2d285772e71506a5752f084d7a90472ff"
      apply "patches/020180821~0d39011.patch",
            "patches/020180821~0edd3d6.patch",
            "patches/020180821~a054156.patch",
            "patches/020180821~b326a71.patch",
            "patches/020180821~c3476dd.patch",
            "patches/020180823~0b6cd19.patch",
            "patches/020180823~8e9ce50.patch",
            "patches/020180823~241d911.patch",
            "patches/020180823~78911a0.patch",
            "patches/020180823~b575e1e.patch",
            "patches/020180823~c432131.patch",
            "patches/020180824~5516c61.patch",
            "patches/020180824~e01e77a.patch"
    end
  end

  bottle do
    sha256 "ce61f1e6b265f170d1ac925fb81c3df1f3f925a649595df2dc034d2ab965477e" => :mojave
    sha256 "0845918822922f58d2626e462c542139508de4719db7dbef90aac3436e45af16" => :high_sierra
    sha256 "912f4c4ac48029b0686f7cdfe64b5cc1e4f9b1c3c19b877e29eb3df3b5f474d4" => :sierra
    sha256 "84742f0e7e695527153fe753d30a5e294722b34db4373a51caa9d08a5eca4168" => :el_capitan
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
  depends_on "libtiff"
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
      --with-system-libtiff
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

