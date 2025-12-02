class Libdbusmenu < Formula
  desc "GLib and Gtk Implementation of the DBusMenu protocol"
  homepage "https://launchpad.net/libdbusmenu"
  url "https://launchpad.net/libdbusmenu/16.04/16.04.0/+download/libdbusmenu-16.04.0.tar.gz"
  sha256 "b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a"
  license any_of: ["GPL-3.0-only", "LGPL-2.1-or-later"]

  bottle do
    sha256                               arm64_tahoe:   "c92c9254f0d9756a4383dd5fec928deb73760c083d07d4f2b77b753970be214e"
    sha256                               arm64_sequoia: "4be53eedb4aa1203f4b6d3e4df0504481f8346db6fc0f6e9e8a27bfbe6f52108"
    sha256                               arm64_sonoma:  "8846a649af9c8584a60204c64f1f83f0590dfdc6739626e77bf6300cec3849c5"
    sha256                               arm64_ventura: "39825e9c8c327dd481f21068e93082328e01d188d61fe87108178c259b6a0354"
    sha256                               sonoma:        "5ad05ed20555b243ad099282e0ac5c910abbc93bb300a30b935cca2f0a26cb03"
    sha256                               ventura:       "febe49bc4a5cc4c94b9b39ecb5acac91d5d8f3f4123a3c3e62c76bc0ffdf8f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd3c91dd313ea60916f30dd136e3ab5a77dcf97978cf841d8c817b822c031a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca161cab45f55b72eeaff556883bf7c38338f3eb120a9a1ab1806caa54aa3801"
  end

  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "fribidi" => :build
  depends_on "gobject-introspection" => :build
  depends_on "graphite2" => :build
  depends_on "intltool" => :build
  depends_on "jpeg" => :build
  depends_on "libepoxy" => :build
  depends_on "libpng" => :build
  depends_on "libtiff" => :build
  depends_on "libx11" => :build
  depends_on "libxau" => :build
  depends_on "libxcb" => :build
  depends_on "libxdamage" => :build
  depends_on "libxdmcp" => :build
  depends_on "libxext" => :build
  depends_on "libxkbcommon" => :build
  depends_on "libxrender" => :build
  depends_on "perl" => :build
  depends_on "perl-xml-parser" => :build
  depends_on "pixman" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "xorgproto" => :build
  depends_on "xz" => :build
  depends_on "zstd" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "json-glib"
  depends_on "pango"

  def install
    # add --disable-tests after https://bugs.launchpad.net/ubuntu/+source/libdbusmenu/+bug/1708938
    # otherwise a patch is necessary, see https://github.com/Homebrew/homebrew-core/pull/230809#issuecomment-3100671936
    # json-glib can be a build only dependency if --disable-tests is used
    args = %W[
      --disable-dumper
      --disable-gcov
      --disable-gtk-doc
      --disable-massivedebugging
      --disable-silent-rules
      --enable-introspection=yes
      --enable-nls
      --enable-vala
      --prefix=#{prefix}
      --with-gtk=3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdbusmenu-glib/menuitem.h>
      #include <assert.h>

      int main() {
        DbusmenuMenuitem *item = dbusmenu_menuitem_new();
        assert(item != NULL);
        g_object_unref(item);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs dbusmenu-glib-0.4 gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           *flags
    system "./test"
  end
end
