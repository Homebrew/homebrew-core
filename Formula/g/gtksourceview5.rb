class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.20/gtksourceview-5.20.0.tar.xz"
  sha256 "e38bcd23f52b86eadf0fe4d8bde698e3a8ca102322b8b4cf1a51ac294a448c1b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "70a17179abf784dd6c8d713c0c982d692c07d91f05b90fca64cc07c1881dd8e9"
    sha256 arm64_sequoia: "405e52ea93ca006b2e0da8976f7f5fd3f434acc2449928221989f55e37d87dd7"
    sha256 arm64_sonoma:  "7675dfa3f0a4c7659e71cf2fb6db2b71b513a2264f90eae0fd805706b4bd1006"
    sha256 sonoma:        "f8ad540c64c2c6915b6dccec298abb7ad268cebd06f9e1b7e2fd9e35c76a7108"
    sha256 arm64_linux:   "efb6484056b6b7aa19f09590fd73304dea43bbd5ca1183f2e2f44cf59ce3a2b6"
    sha256 x86_64_linux:  "3cd0683c7d6775ae957e80bca3e6bb8081271904b9395d614ae6b3d5870698aa"
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
