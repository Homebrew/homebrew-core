class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.1.tar.xz"
  sha256 "8ec44f32052e896fcdd4926eb814a326e39a5047e251eec7b9056fbd9444b0f1"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "613457070f16302750abb018bf2a5d76c4d284dd1d1cdcb58d080e1ff6f99b1a"
    sha256 arm64_monterey: "3b0fa712f20b04133470e7b432df1a2118285afc9e76f52ff936092f2a963047"
    sha256 arm64_big_sur:  "3723d3e9c9561ff49e0e47f330e4477723449a59df76d7c71056a3f270f1952c"
    sha256 ventura:        "331130b78ba758cdd10a43d77516e524ce7d8d84f2bb0a8522860ba39db3256f"
    sha256 monterey:       "fba198d568698e094caf88b351a817e331ab5b2eba1fc34d55f1c4434d260b63"
    sha256 big_sur:        "4bb40dc090298d0bafd1a24be66a36acbdb82f27d5a8606c6878c69219764e8e"
    sha256 x86_64_linux:   "c48d0a10dd6627c219b6ba5d51a26cc883cd3cb1cbeae5d59bf0afa0c33c6257"
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
