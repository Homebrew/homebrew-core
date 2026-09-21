class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  license "GPL-2.0-or-later"
  revision 10

  stable do
    url "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
    mirror "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
    sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"

    # Backport fix to support ARM macOS and fix build with Xcode 15+
    # Ref: https://github.com/gnu-smalltalk/smalltalk/commit/bf3fd4b501c71efa86d7f91d5127cab621245a8d
    # Ref: https://github.com/gnu-smalltalk/smalltalk/commit/7456c7a4fe34210ad3d34b6a596dc992045d3830
    on_macos do
      patch :DATA
    end
  end

  bottle do
    rebuild 4
    sha256 arm64_golden_gate: "946911395ee208cc47695bd6451fe03afcd4619657b15ee3154f4c72fe55fc35"
    sha256 arm64_tahoe:       "1935af530752ba55c1e8bf8f78fb342ef198ef1b5341c1513b7455965a471f1b"
    sha256 arm64_sequoia:     "06e05353ca26a07e110fcebac0fb9276ce3ba2a5db94460e427b4faa4bbdff24"
    sha256 arm64_linux:       "63970f55e4a310e87ef69229c1697d9d86e36eef66ee206de490ab36e436e648"
    sha256 x86_64_linux:      "b368bc7382d041b256856c7cdb6335f640f20931c925386cf672563e308cdb6b"
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
  depends_on "pkgconf" => :build
  depends_on "gdbm"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "zip" => :build
  uses_from_macos "expat"
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
    end

    args = %W[
      --disable-gtk
      --with-lispdir=#{elisp}
      --with-readline=#{formula_opt_lib("readline")}
      --without-tcl
      --without-tk
      --without-x
    ]

    # K&R function definitions in the bundled getopt are invalid in the C23 default that autoconf 2.73 picks
    ENV["ac_cv_prog_cc_c23"] = "no"
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
