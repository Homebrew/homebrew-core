class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.0.tar.xz"
  sha256 "40d2850f1bb6e8775246fa1e39438b36caafbdbada1d28a19fa1ca07e1ff82ad"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "65c906574ff5e87056ca93c2f85d6c3b23eaa4650a1f24b5dee72da575101c9f"
    sha256 arm64_monterey: "d7c62a15ae3002daa6e3b8a34db896890eb7e540d308b1af38fae9e934eb968b"
    sha256 arm64_big_sur:  "afdc49aec4ce907138b80adfb2b85c9166850f3d405f646c919927d4d0bfc61a"
    sha256 ventura:        "962ac8b16ebac953aa098fe234d6603e2bc7a388791dc40b5f23ba6f1f7775cf"
    sha256 monterey:       "98e5a2909232aa846d11fa5b08ae36194953a29595e50a8abd2092d8ab145ba4"
    sha256 big_sur:        "d8f6031f9bfa590015cd06a9390dab16ec90e0507d97b7f4b16ba683c9115791"
    sha256 x86_64_linux:   "1dad36d3cd68e3c2b15b8ab4a0d82eb145276bdc58f017319512aafc9a25bd04"
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
