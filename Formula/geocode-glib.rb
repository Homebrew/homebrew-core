class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://gitlab.gnome.org/GNOME/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.4.tar.xz"
  sha256 "2d9a6826d158470449a173871221596da0f83ebdcff98b90c7049089056a37aa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_ventura:  "810645cd7021c31a2b79a367a46341a119235b6edd9762d520f2e4742d85a152"
    sha256 cellar: :any, arm64_monterey: "cd7f32a773538d43539177540e21bee914a32fab1ac0497e9867cf49bc7926fe"
    sha256 cellar: :any, arm64_big_sur:  "a87fb2ae45e7bc56fd06e61f0260217506aaa6fadd4040305b424fbc3e292ac8"
    sha256 cellar: :any, ventura:        "53824bb51dce74868891a9ecf72b35688fa5d642f812f9bbcbd2f97627b7b659"
    sha256 cellar: :any, monterey:       "657fcab9602371c260494510436cecf83e37f7526e2d96fd9ee87b133fd73547"
    sha256 cellar: :any, big_sur:        "46f8b7fb5ae054a58b11bf54b7869335fa7b29b82875dbe4f14b9aa50b43c7cb"
    sha256 cellar: :any, catalina:       "f4715dbb2ed9bb363a61f0e40c885f3218262d87bf1a22a1f341c6acdab3cf56"
    sha256               x86_64_linux:   "705672b2c649c9dad5061d9d010d6faa106f67a278e90eab7c6b6a7a8f66e9ca"
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
