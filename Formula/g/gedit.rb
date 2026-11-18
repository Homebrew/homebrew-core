class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/51.1/gedit-51.1.tar.bz2"
  sha256 "7e99664c8c37818cd2bd39d06ba0806eae0d8719772404253b648fa689782def"
  license "GPL-2.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/gedit.git", branch: "main"

  bottle do
    manifest_sha256 "0ea25559e7ac38333b2cb18aea7c44c78374cbcbde9e4562680ceb4d42219293"
    sha256 arm64_golden_gate: "bd924bff8335ccf08401a5b0865b97c7640273447825199b266cc39e1d7c2a03"
    sha256 arm64_tahoe:       "28126b2fa23011ebad5c01a6d506b6fb4be2881864acff4f0e0a929353481cf2"
    sha256 arm64_sequoia:     "209a80c3534e2cc8468703ad8ca3a411ad123b1e5821048f1a3c46d1b5727e0e"
    sha256 arm64_linux:       "1bfcaae2f712eeb2beb38088ec9d568ea3d59fe4ce8efded41f45edff5166179"
    sha256 x86_64_linux:      "879f89739b60e56f83310356275e2119aa4584097c8aaa83df26f12d7220a6bc"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

  deny_network_access!

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("icu4c")/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", dep("libpeas").opt_lib/"pkgconfig"

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
