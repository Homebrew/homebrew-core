class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  license "GPL-2.0-or-later"
  revision 10

  stable do
    url "https://ftpmirror.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
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
    rebuild 3
    sha256 arm64_tahoe:   "0b4242a4f666b10130804e15b8ac1cb06db8ca8c2dce4b3ff22809b27e3bed03"
    sha256 arm64_sequoia: "baa1b37e3cc684dae9fa2bec7372228339adfc3c775a95ce93553f72249d9516"
    sha256 arm64_sonoma:  "29864f96663e3b39da8d1b27e896ccf7d76921dea8a950a155b8a931f49a1ef3"
    sha256 sonoma:        "8153d28cbf7150c2c8f5067f37f8ff9a0fe6c2dcfda627d3838fd02130ca0b3c"
    sha256 arm64_linux:   "0c98372d450e874686423037537b0be9f07793cb285b8e63b7d5ab5318354b02"
    sha256 x86_64_linux:  "e4cbaebdce96bc94f1fe18569515079f6c6e370146805bb04a6e4bbc7e19a331"
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
