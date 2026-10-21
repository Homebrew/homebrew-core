class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.8.0/libgedit-gtksourceview-299.8.0.tar.bz2"
  sha256 "0fed8e7ec13b435bae8d20d2cac68d609757517e5c6faca2f78733878e4246ce"
  license "LGPL-2.1-only"
  compatibility_version 2
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "d4e6f01ac5c1c25727ae062e715b3b94eea554eab8faf23b8d822828dac8b091"
    sha256 arm64_tahoe:       "8612aa3f63a74a13f363f33dd1066e7a467b37b195a72551d71780684a0c1485"
    sha256 arm64_sequoia:     "fa71cb015997703937d7a05f68254f5f64b31eb9357efeb9cd2a6001924d444b"
    sha256 arm64_linux:       "a99edd0b1d46b4f74fbbc5c4e200504a77d74b842a800ff2a99b97dca64d4dbc"
    sha256 x86_64_linux:      "cd8ef4543e193327d6ce78509978c6978adba23cacf7f858cef4cbffc71f9f09"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
