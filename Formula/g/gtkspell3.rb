class Gtkspell3 < Formula
  desc "Gtk widget for highlighting and replacing misspelled words"
  homepage "https://gtkspell.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtkspell/3.0.10/gtkspell3-3.0.10.tar.xz"
  sha256 "b040f63836b347eb344f5542443dc254621805072f7141d49c067ecb5a375732"
  license "GPL-2.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "b64eeabbec9be14150c26d9213d525edb028af2546a0a1d85ea26e55d26d3b9d"
    sha256 arm64_sequoia:  "f182f8a623b04c25479cfedab38fcc1bc4c6df7f548b7c3b1ceab211fbe16115"
    sha256 arm64_sonoma:   "af4e893051ace858028bf47a7fe57524b6fefddb105ec7325301468135ee2d1c"
    sha256 arm64_ventura:  "99fdc129ff12ac2e004114076b278d7b7b62b0fc7f6ffc7f40a3eaa186bbb795"
    sha256 arm64_monterey: "c6b206d892fa7aa21650a0567741479e6b916f0c4e18683232be43845a4bc797"
    sha256 sonoma:         "0db8568fa754d743a6ee0a2e10804a464575a7cb2981599c4fccb0de4ff6fc10"
    sha256 ventura:        "8327e4eb37ec513c654f28d3c4bc1602fe19d0984f46fffae5bae668b526085e"
    sha256 monterey:       "6e04d8a356a3f3dadeef039a3b3e7218f44b7cc53ce720ab4e7273273749b6a2"
    sha256 arm64_linux:    "2107b9a48ac875459316fe149288cd8d0c48d1069000f009f15b007836a789df"
    sha256 x86_64_linux:   "e59e7ffb60fbef74bbfd6c8191776880cf5b4cb697c5519dfcdf7f1e1a29fccf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-vala", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtkspell/gtkspell.h>

      int main(int argc, char *argv[]) {
        GList *list = gtk_spell_checker_get_language_list();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtkspell3-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
