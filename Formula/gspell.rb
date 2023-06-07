class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.1.tar.xz"
  sha256 "8ec44f32052e896fcdd4926eb814a326e39a5047e251eec7b9056fbd9444b0f1"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "2f8f0a499fe66a7bb153b1bd6886f24c5ef85d099c7932f367561c9b518607ce"
    sha256 arm64_monterey: "c3da9f5a10b55fe211303b8d4df9d987da21e9d98cebcdf8eaf4bc5d5ee539d1"
    sha256 arm64_big_sur:  "b097e3fcadd32de96141c7085e7c4c356ffaca1f25cb80659125fdb363661e82"
    sha256 ventura:        "f6b230a8909ef4830c832317288b5c47a5c585f199e8729e4076111fcb97370d"
    sha256 monterey:       "a885b47724bc86a8988983fcf7b5b00b835e859b7cd8b5cfe3ec2db4762f4d8a"
    sha256 big_sur:        "b1c6c60661aa3f128997729cdeb835ca8b1dee9aeb28e2fde8922a9734af347f"
    sha256 x86_64_linux:   "bde02f4095ff64809fbe36b78dcd9ef7abeb469b0fc63413417a9edd689d11c3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gtk-mac-integration"

    patch :DATA
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-introspection=yes",
                          "--enable-vala=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end

__END__
diff --git a/gspell/Makefile.am b/gspell/Makefile.am
index 076a9fd..6c67184 100644
--- a/gspell/Makefile.am
+++ b/gspell/Makefile.am
@@ -91,6 +91,7 @@ nodist_libgspell_core_la_SOURCES = \
	$(BUILT_SOURCES)

 libgspell_core_la_LIBADD =	\
+	$(GTK_MAC_LIBS) \
	$(CODE_COVERAGE_LIBS)

 libgspell_core_la_CFLAGS =	\
@@ -155,6 +156,12 @@ gspell_private_headers += \
 gspell_private_c_files += \
	gspell-osx.c

+libgspell_core_la_CFLAGS += \
+	-xobjective-c
+
+libgspell_core_la_LDFLAGS += \
+	-framework Cocoa
+
 endif # OS_OSX

 if HAVE_INTROSPECTION
