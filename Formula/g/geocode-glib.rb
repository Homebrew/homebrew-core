class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://gitlab.gnome.org/GNOME/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.4.tar.xz"
  sha256 "2d9a6826d158470449a173871221596da0f83ebdcff98b90c7049089056a37aa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "099ca3555aed8dc105d24af84e64cbf301d1a825b27e439714253f01e4b46860"
    sha256 cellar: :any, arm64_sequoia: "768df1fedb60223b40e5ae28bae291d3a1ab29348c933914e07eec499b411493"
    sha256 cellar: :any, arm64_sonoma:  "71da878f8fa832ff9be93eb4bd9eb273edc56fbfa0fcce78451fec9973d7b1ee"
    sha256 cellar: :any, sonoma:        "3e85bc0052a76a49df989312c340673b51a9fc78ca30aa9884c1a4b70a82f536"
    sha256               arm64_linux:   "b73ca42db92e01ef70a73d5d9ce30931b9499c97f250630f458ec5786053311f"
    sha256               x86_64_linux:  "f369360a77dea34b0c9d574eef1d491a3eca20c1271d9e5a29c30fdf48ad5ccf"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    args = %w[
      -Denable-installed-tests=false
      -Denable-gtk-doc=false
      -Dsoup2=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    update_gtk_icon_cache
  end

  test do
    (testpath/"test.c").write <<~C
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    C
    pkgconf_flags = shell_output("pkgconf --cflags --libs geocode-glib-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
