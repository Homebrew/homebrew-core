class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  license "GPL-2.0"
  revision 10

  stable do
    url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
    mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
    sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"

    # Backport fix to support ARM macOS and fix build with Xcode 15+
    # Ref: https://github.com/gnu-smalltalk/smalltalk/commit/bf3fd4b501c71efa86d7f91d5127cab621245a8d
    # Ref: https://github.com/gnu-smalltalk/smalltalk/commit/7456c7a4fe34210ad3d34b6a596dc992045d3830
    on_macos do
      patch :DATA
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "d8fae2219f2257f6d225d46bfd70f91ba8021e7679e32e38e3397ef688384509"
    sha256 arm64_ventura:  "4de8a4750039f3dc1dd6b79a33f0e309cadd5c9f7fd4bedca768c2bc32899d51"
    sha256 arm64_monterey: "62a1595337f20f89ec9004114659b91cddaa674018b3f52127d5f9be56bbc247"
    sha256 sonoma:         "004d31cd45e95d426796626816a456b8372ec00038239771ab20448fd9655afc"
    sha256 ventura:        "0d0749c9612ed7111d1e923e6cdee688f5aa2943dfbd45a62ab4701074b06fcf"
    sha256 monterey:       "a1fc98f122660e0bcf6005eb04cdc7ab941e4e44ee888ca20de10a411f1d2938"
    sha256 big_sur:        "3de7522ec83425a3ad683f0050298630d3a1dfe4065cd5f57c8e18e266e434d8"
    sha256 catalina:       "b389791ed3f702f317883b54421e9a47122326607b603a592dd5903a057ff344"
    sha256 x86_64_linux:   "d10915dea08be1b60576263f619653fca70471bfa64a07f1a0d73eac94055362"
  end

  head do
    url "https://github.com/gnu-smalltalk/smalltalk.git", branch: "master"

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "zip" => :build
  uses_from_macos "expat"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
    end

    args = %W[
      --disable-gtk
      --with-lispdir=#{elisp}
      --with-readline=#{Formula["readline"].opt_lib}
      --without-tcl
      --without-tk
      --without-x
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    ENV.deparallelize if build.head?
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end

__END__
--- a/libgst/sysdep/posix/mem.c
+++ b/libgst/sysdep/posix/mem.c
@@ -225,7 +225,7 @@ PTR
 anon_mmap_commit (PTR base, size_t size)
 {
   PTR result = mmap (base, size,
-   		     PROT_READ | PROT_WRITE | PROT_EXEC,
+		     PROT_READ | PROT_WRITE,
 		     MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);

   return UNCOMMON (result == MAP_FAILED) ? NULL : result;
--- a/Makefile.am
+++ b/Makefile.am
@@ -110,7 +110,7 @@ bin_PROGRAMS = gst
 gst_SOURCES = main.c
 gst_LDADD = libgst/libgst.la lib-src/library.la @ICON@
 gst_DEPENDENCIES = libgst/libgst.la lib-src/library.la @ICON@
-gst_LDFLAGS = -export-dynamic $(RELOC_LDFLAGS) $(LIBFFI_EXECUTABLE_LDFLAGS)
+gst_LDFLAGS = -export-dynamic $(RELOC_LDFLAGS)
 
 # The single gst-tool executable is installed with multiple names, hence
 # we use noinst here.
@@ -118,7 +118,7 @@ noinst_PROGRAMS = gst-tool
 gst_tool_SOURCES = gst-tool.c
 gst_tool_LDADD = libgst/libgst.la lib-src/library.la @ICON@
 gst_tool_DEPENDENCIES = libgst/libgst.la lib-src/library.la @ICON@
-gst_tool_LDFLAGS = -export-dynamic $(RELOC_LDFLAGS) $(LIBFFI_EXECUTABLE_LDFLAGS)
+gst_tool_LDFLAGS = -export-dynamic $(RELOC_LDFLAGS)
 
 # Used to call the Unix zip from Wine
 EXTRA_PROGRAMS = winewrapper
