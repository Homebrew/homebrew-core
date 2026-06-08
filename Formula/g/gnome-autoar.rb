class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.4/gnome-autoar-0.4.5.tar.xz"
  sha256 "838c5306fc38bfaa2f23abe24262f4bf15771e3303fb5dcb74f5b9c7a615dabe"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "e989aba6c89f26eb5a551f54006af3f52408071a32cf0a6e32befa60c79cfe61"
    sha256 cellar: :any, arm64_sequoia: "83d4a5f33857515b1a11149a955dd293411f6648b983304a8388f8cb2dbc6174"
    sha256 cellar: :any, arm64_sonoma:  "5b8a042462f7b953f9d0ca1ee8dcbf7f8802fccf79b666b253368923d06cdbd2"
    sha256 cellar: :any, sonoma:        "2785109ee3638584ee08d1ac71cd1a5ac71520b2309c81ad41da1102b35b5540"
    sha256               arm64_linux:   "5c4524e591a8f0475cc70d08c9515467b643514164adfd165e4a1cf2454033c4"
    sha256               x86_64_linux:  "7130c2c436ce821f2a7154113ddf5028eb3e4b9674b5b9e50e0ae64d11e96aab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libarchive"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gnome-autoar/gnome-autoar.h>

      int main(int argc, char *argv[]) {
        GType type = autoar_extractor_get_type();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gnome-autoar-0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
