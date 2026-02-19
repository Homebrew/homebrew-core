class Libhandy < Formula
  desc "Building blocks for modern adaptive GNOME apps"
  homepage "https://gitlab.gnome.org/GNOME/libhandy"
  url "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.8.3/libhandy-1.8.3.tar.gz"
  sha256 "7e7670f5d0a6d0adc24b888da44dab938a6f52472b8944d6dd4e31b6d3569a5f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:    "620cf34883ae285873425a4f3ffa156b78e8b696872bd20b425008488ad0d232"
    sha256 arm64_sequoia:  "df4227eb5f6062d4b9d6c36d374defe991229ee0ed9dc8e8902c97a1be026151"
    sha256 arm64_sonoma:   "f1b399070cea7b5c44e3afad605155f867659920d5d3de17c466cf5cc3ba6a33"
    sha256 arm64_ventura:  "46282e234e80d7e1333fd66978709232ccd69517759099868c386c6eec51ca84"
    sha256 arm64_monterey: "2efac67c62c3b8da9bdb64fb4b37a0c66b184239009feb39d5407431b6f9b4e8"
    sha256 sonoma:         "b7451a9bbf91864a025ac3df2473f9dc91398b22d3994f4cc9907344e9be6f1f"
    sha256 ventura:        "ac6d97fd95891df7ecfa6caf13d15c28c153db6fea7da1dd9aee2e56c4780a59"
    sha256 monterey:       "9b94bd79179daca2b005bdd61ba0f1fcefdcd2b19ab85a9e5732f8c2f0428315"
    sha256 arm64_linux:    "9c76cf625f3b293b62040fd9663afb365c5606479dd08b37871304e7e913f6b8"
    sha256 x86_64_linux:   "6b470387d368374a5834bb3a73c2d0fcc4cc16121e785a064913735356581e85"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "meson", "setup", "build", "-Dglade_catalog=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>
      #include <handy.h>
      int main(int argc, char *argv[]) {
        gtk_init (&argc, &argv);
        hdy_init ();
        HdyLeaflet *leaflet = HDY_LEAFLET (hdy_leaflet_new ());
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libhandy-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    # Don't have X/Wayland in Docker
    system "./test" if OS.mac?
  end
end
