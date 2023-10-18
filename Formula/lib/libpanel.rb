class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.4/libpanel-1.4.0.tar.xz"
  sha256 "80f143d900e8ced8ff84fa86fe34eb6b48323cb610bcfb6858ea65d8b98f152c"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "05926ef5ac606543169695fd8f2fa066680b769093107b94d3ed709e11af87ba"
    sha256 arm64_ventura:  "4d9038d39d8a1d26c819b826182e05a6c305f99f6af8aaff50af0e72d841b8fe"
    sha256 arm64_monterey: "e80757383b0c9a56a79321773019108a7cf3a3975af9aef8735cc80499098e83"
    sha256 arm64_big_sur:  "6eb6b4ecc13d19ac6faf136a9b48b23235bfc73b3a140d7d07dc14947a3e1543"
    sha256 sonoma:         "acde7e3e5fef0e04ae67bf83870789be169885fef9d129eaceaaa25576114ddd"
    sha256 ventura:        "60e6d7024f4494a033e6554234aff4e37183a4f7e4afac2bb883d0a9c1f00233"
    sha256 monterey:       "d44c1ce8f287d87ae41100dda88377226bd51f257d0ea61eb4c40ea99d9d8fa8"
    sha256 big_sur:        "2892c67c65a5e37db093ab8d4cd1859b67297dc84daf161de73bcc70b1c47eff"
    sha256 x86_64_linux:   "257d5c5a9db1931ae98315aeaa059c98f01ba2745279815e440178b5bcbf4397"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gi-docgen"
  depends_on "gtk4"
  depends_on "libadwaita"

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpanel.h>

      int main(int argc, char *argv[]) {
        uint major = panel_get_major_version();
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libpanel-1").strip.split
    flags += shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libpanel-1.pc").read
  end
end
