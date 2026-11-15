class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.22/gtksourceview-5.22.0.tar.xz"
  sha256 "3ebce33c781e65590a450ecd3ffade480d8e3135b52ee996f1620d6c7dffbbff"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2931e55af2dbf475c3aa25d01e0868d10cb37be886a8ea6dfba91613237fe959"
    sha256 arm64_tahoe:       "4cc2c1c2f338e83b99fe83ceffa2dee6a9632a3912536b640b954b6718212b08"
    sha256 arm64_sequoia:     "c52f0d6c7ba5bc3f367c77cab1d08f4d416ea4c1a5fd239e929ff8659d666a14"
    sha256 arm64_linux:       "f8c7ab656dfefc30f831735456cf6294ce14db002461422a558a8e1a22702d4d"
    sha256 x86_64_linux:      "8f95f0e981a2d2defd89e3043f83294697f8ad872a5ea2fa1a410d59892689f8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
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

    flags = shell_output("pkgconf --cflags --libs gtksourceview-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
