class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://gitlab.gnome.org/GNOME/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.4.tar.xz"
  sha256 "2d9a6826d158470449a173871221596da0f83ebdcff98b90c7049089056a37aa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "e05e16cff98263e502be86ba8e0dacc2b9db8c206ab2e39328aa251958fa46ff"
    sha256 cellar: :any, arm64_big_sur:  "5dc4f7038ee843898bc1d66c831de594045bc07d75803d9ceeb439979e974635"
    sha256 cellar: :any, monterey:       "a852370762b744056678baa6be4c500f2ed664ac62e7e8f5158601b076526216"
    sha256 cellar: :any, big_sur:        "641b09e8c9fc3bfcd486651f28cac679dde0d14c7d70d026030d8cb2e05848f7"
    sha256 cellar: :any, catalina:       "d89e09d0947a2aaf675a5039e7199518592f19611a5cd21f0edda22cbf4d16d2"
    sha256               x86_64_linux:   "e0224472f08ddfa0a81deb972c4bb6e15e1ff8ae53df5cbe47d130f20a7aa8fc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    system "meson", *std_meson_args, "build",
                    "-Denable-installed-tests=false",
                    "-Denable-gtk-doc=false",
                    "-Dsoup2=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    pkg_config_flags = shell_output("pkg-config --cflags --libs geocode-glib-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
