class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.4/gnome-autoar-0.4.4.tar.xz"
  sha256 "c0afbe333bcf3cb1441a1f574cc8ec7b1b8197779145d4edeee2896fdacfc3c2"
  license "LGPL-2.1-or-later"
  revision 1

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "06419877711b70b28bfefab656263799dc2e171385758835c8a3f3fb9c96a383"
    sha256 cellar: :any, arm64_ventura:  "92031670a7ac7d4e194682d50b5d1e82e8f8649dde19666f51df72c15e6a1f50"
    sha256 cellar: :any, arm64_monterey: "30c9eba06e7b6aad5c74ef031f6464200d74afa66dc7cf456dad9ad84b5b9b9b"
    sha256 cellar: :any, sonoma:         "5d4ec86efc0c3643cf9c2928f9c1bd124bc911fdeb591a1f7be94ada8357b510"
    sha256 cellar: :any, ventura:        "105dd6c94a1b2663cfc9f2f20763530ab2f6de724da58f4023e8297b33b2faa9"
    sha256 cellar: :any, monterey:       "5604b33340461e53b24bd9e9152356864bb21282605b562c2c2a8214a4bb7994"
    sha256               x86_64_linux:   "6787a6ab007ee12dccedee1c9be590a1e15d6bac032906b1225cee26cd9d31d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

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
    (testpath/"test.c").write <<~EOS
      #include <gnome-autoar/gnome-autoar.h>

      int main(int argc, char *argv[]) {
        GType type = autoar_extractor_get_type();
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs gnome-autoar-0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
