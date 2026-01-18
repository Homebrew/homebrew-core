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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "11802ea09914aaed9ad773498371bfcbd35bebd339d82455c8e9b7d15a7a6ba2"
    sha256 arm64_sequoia: "fa42deb9637324919358ee25610a53e01088fb726c82f4128f9472da1311935c"
    sha256 arm64_sonoma:  "1a03cac9ae46b6523cc6353c3714b2fd5d1151df2d41fc3929d3c03bab813917"
    sha256 arm64_ventura: "e737012cfb9f7029528a4f733125cc9dcf710b7f70fa2d2c19e5bbd16e7a6141"
    sha256 sonoma:        "0ee808a189abc91152255eb4b7401e56dafa3cad5a226b898e84aaf7a37fbdcf"
    sha256 ventura:       "a4df3db5ceb9a6d123906ee112131e3a33a25bc484124e3eaaf63858930492b7"
    sha256 arm64_linux:   "cbecc28a3dc88c1ccd58ecf2facfd8d9f0edd686e31334b1c93dd82d4a8bc8f6"
    sha256 x86_64_linux:  "f3cc37783b2695b0a1fa9e8fd21e7b4b2a77f10a4aa0c9a97d4e86fbb2e6a524"
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
