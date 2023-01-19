class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.0.tar.xz"
  sha256 "40d2850f1bb6e8775246fa1e39438b36caafbdbada1d28a19fa1ca07e1ff82ad"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "de7469b30c9c17a2914a840cc474b23ad3c16f68d0f57c1f1834bc931a996297"
    sha256 arm64_monterey: "a8aa160e46dd71a143e009f66eb0164ccea88b10954b8792ffa8ab8ccf01141c"
    sha256 arm64_big_sur:  "e8b3bfdaca0a6a27bcd2ff5e3e4cc9227ec73a9a47378bbcdb2492f07c9bbe0c"
    sha256 ventura:        "9f094a7a23f75800fa7359bfe06f8bdebc351f1962df49b47550f5ef08203ec5"
    sha256 monterey:       "2777e111e6c74f706b19bb044d52527bb5db78fa49c3d2ab5bce22e07571b733"
    sha256 big_sur:        "2f86453a5b333727061aaf2ec9a7fb35d4907d193eb4b60c49e6208b722f1ca2"
    sha256 x86_64_linux:   "ea56b56fe83fdceac890b81db9bb2828379b2275804a555d16ce250b21b78c54"
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
