class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.40/glade-3.40.0.tar.xz"
  sha256 "31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e0a5106b1b40c33b0637a7b713a544023d04aef3006600771947360bcfafe5bf"
    sha256 arm64_sequoia: "7faf1cfde42ae08400dbe029171e8e0c28e56da3f8a105248a3dcdaab7444477"
    sha256 arm64_sonoma:  "7821188717113ff0e90a2dcd0784710daeacc2e8eb0bae549538b7ec937ae952"
    sha256 sonoma:        "3f9b197634b5fad04891dd5181201cfe00ebf6cff650e348b3983862a5cb2d7c"
    sha256 arm64_linux:   "14206c16e70adf01ddcbc74e3ba1b70171312cca1a6074abbac2c688dce408ce"
    sha256 x86_64_linux:  "ca74259d91f9c96f10b28453ed7a8f205267d94687ebfc4c79563e80b839287b"
  end

  # https://gitlab.gnome.org/GNOME/glade (archived)
  # https://glade.gnome.org/news.html
  # > Glade is not being actively developed or maintained anymore
  deprecate! date: "2026-01-30", because: :repo_archived
  disable! date: "2027-01-30", because: :repo_archived

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme" => :no_linkage
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "libxslt" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable icon-cache update
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=true", "-Dgladeui=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    gtk_update_icon_cache
  end

  test do
    # executable test (GUI)
    # fails in Linux CI with (glade:20337): Gtk-WARNING **: 21:45:31.876: cannot open display:
    system bin/"glade", "--version" if OS.mac?

    (testpath/"test.c").write <<~C
      #include <gladeui/glade.h>

      int main(int argc, char *argv[]) {
        gboolean glade_util_have_devhelp();
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs gladeui-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
