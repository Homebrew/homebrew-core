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
    sha256 cellar: :any, arm64_tahoe:    "21f6cb50309fa7fac08d920133ce5d38ef1cc733a11f742617dbeb336c8b7a9e"
    sha256 cellar: :any, arm64_sequoia:  "82a0ecb8777d13f3ce427459f14143f538e2a7cb709b17436e8bfdd5418e2330"
    sha256 cellar: :any, arm64_sonoma:   "dd87d22bf4ee53a96407ff2516c9893ed0e8ed49f22300b166908756fa424092"
    sha256 cellar: :any, arm64_ventura:  "a3cca1e7e9e0f12e2f25dcbad3698ccbc249e943d0d659225f03631f819bff3a"
    sha256 cellar: :any, arm64_monterey: "4067fd35e3d4905a49adf80fddd05785b69981e77a0d3ca5d48b55362b837eea"
    sha256 cellar: :any, sonoma:         "9f4b8685e8bd77328158b651a82d8bf0e746ee94dcab600a8ce8fbc3a695d245"
    sha256 cellar: :any, ventura:        "07977233fa05e74baadaaf3767fbf16925aa9ea6b8a767491d5820f8fa6fc196"
    sha256 cellar: :any, monterey:       "6a277a2676b485946d376fa51f6ceed08394b68d3b616d2db8692ad4b982c13e"
    sha256               arm64_linux:    "d6d7a1143bac8c867757bf8255e712bf6e6cb87c09ef9936da0fa77677b80069"
    sha256               x86_64_linux:   "7fbef3923b41a565fb1b76d5cde929366f917d22e0342da607b7d8a15827a8bc"
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

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
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
