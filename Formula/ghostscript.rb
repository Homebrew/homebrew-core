class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "http://www.ghostscript.com/"

  stable do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs919/ghostscript-9.19.tar.gz"
    sha256 "cf3c0dce67db1557a87366969945f9c5235887989c0b585e037af366dc035989"

    # http://djvu.sourceforge.net/gsdjvu.html
    # Can't get 1.8 to compile, but feel free to open PR if you can.
    resource "djvu" do
      url "https://downloads.sourceforge.net/project/djvu/GSDjVu/1.6/gsdjvu-1.6.tar.gz"
      sha256 "6236b14b79345eda87cce9ba22387e166e7614cca2ca86b1c6f0d611c26005df"
    end
  end

  bottle do
    sha256 "70d001f1d73c2e270dc2a0d438f038150e091118dabb12a1edb36843c781e10c" => :sierra
    sha256 "eeca121b96926b72e10f2bc75be45a2739ce9b57eba5ebbc6eac945db01aa542" => :el_capitan
    sha256 "85459cef5b92ffb8ee30ab6af1a0649b2698716b4a9c23f12cf39f4435b3e542" => :yosemite
    sha256 "bbf4584ed19c2c38530c9b1e77c543370a77e441b759f519bb8b80fa9b41ebec" => :mavericks
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "git://git.ghostscript.com/ghostpdl.git", :shallow => false

    resource "djvu" do
      url "git://git.code.sf.net/p/djvu/gsdjvu-git"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  patch :DATA # Uncomment macOS-specific make vars

  option "with-djvu", "Build drivers for DjVU file format"

  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "djvulibre" if build.with? "djvu"
  depends_on :x11 => :optional

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  def install
    if build.with? "djvu"
      resource("djvu").stage do
        inreplace "gsdjvu.mak", "$(GL", "$(DEV"
        (buildpath+"devices").install "gdevdjvu.c"
        (buildpath+"lib").install "ps2utf8.ps"
        ENV["EXTRA_INIT_FILES"] = "ps2utf8.ps"
        (buildpath/"devices/contrib.mak").open("a") { |f| f.write(File.read("gsdjvu.mak")) }
      end
    end

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

    if build.with? "djvu"
      inreplace "Makefile" do |s|
        s.change_make_var!("DEVICE_DEVS17", "$(DD)djvumask.dev $(DD)djvusep.dev")
      end
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
 
 
 # macOS
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

