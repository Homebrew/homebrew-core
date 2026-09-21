class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.5/gnome-autoar-0.5.2.tar.xz"
  sha256 "6c20bd16c87aba15869e56444424481f632ac302989a203e8ce4dcc73dea33a5"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61d6d8f9a50af982ec4ddf0a7e3b3e26a0f44c0f96ffc471717443411eec1b23"
    sha256 cellar: :any, arm64_tahoe:       "e55340827c5750f4a79057710c350994b6e38a7aec2968ad72f2a0881ca4d931"
    sha256 cellar: :any, arm64_sequoia:     "8ce9e8b6a660655a3f91aad4c39be3659c583e8747ed5ab53e81d8dca0c2db86"
    sha256 cellar: :any, arm64_sonoma:      "497c2c6f8b61c2cf4e2772661a83a14253b040c105542da2c763a4fd4be69192"
    sha256 cellar: :any, arm64_linux:       "5056db5ff19505d9f941e8a3c491abe3dd1cdf0cb231011100c3316cbfe15a7a"
    sha256 cellar: :any, x86_64_linux:      "4ca8ac8ac5837114ba173f19f1265e3e184c43849b45543a567e0575c28a4deb"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libarchive")/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gnome-autoar-0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
