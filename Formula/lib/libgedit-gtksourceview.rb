class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.7.0/libgedit-gtksourceview-299.7.0.tar.bz2"
  sha256 "c0baf7fcf756ad0b47150ea17e5de2cacb0833bbda13c6a625f57f3d00aee0bf"
  license "LGPL-2.1-only"
  compatibility_version 2
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "eba7a448ca965a266c5a9a3969e8c94b15772a496c0eff4c50d3d7acc51dc4d0"
    sha256 arm64_sequoia: "0b42ea6b5f592fb0bb96cccd4a547ccb9d896b4269e9796d8f863107b2afc841"
    sha256 arm64_sonoma:  "4495cb21c41a9acbbb3a9393e2e225792aea8e9d8a97b770433c68bdd1e1f928"
    sha256 sonoma:        "5c8b691f879716d205ee45bf1bb9f38bb922b2e13e31236f7b5ad206868f74bb"
    sha256 arm64_linux:   "bcb0352ccb950ff2da94a53498d967f10b2e14583761bc4308b3557c69ad5928"
    sha256 x86_64_linux:  "41b20d077bea751936bb953453dfc8e7bc7d9c93df1d0db3dabc4b2e7c2be512"
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
