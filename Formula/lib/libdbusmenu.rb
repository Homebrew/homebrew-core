class Libdbusmenu < Formula
  desc "GLib and Gtk Implementation of the DBusMenu protocol"
  homepage "https://launchpad.net/libdbusmenu"
  url "https://launchpad.net/libdbusmenu/16.04/16.04.0/+download/libdbusmenu-16.04.0.tar.gz"
  sha256 "b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a"
  license any_of: ["GPL-3.0-only", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "39c6193c2a776a1184274c4132d659b3922929f355416846cc1e09f858fb763e"
    sha256                               arm64_sequoia: "35dd5ba680220be9552195596fc39fc285cb4badc56ecc86174bdc959a5d3a34"
    sha256                               arm64_sonoma:  "95ac2e098777206c685379fe6b57d4a6727f59a69f949df60b3a825cc8a90031"
    sha256                               sonoma:        "e0527bd20da98e4b479e6e9bfa60f786382b01ad98670eadf37ce4b665db248c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a30a7008ce1dec8063c73449094da31626de9ce44e35ad1ca4b06d690f0874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972661b3c937df6ef53985b8d3c986af8478834680126dc7f8557751b01d065c"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

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
