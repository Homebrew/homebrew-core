class Libgudev < Formula
  desc "GObject bindings for libudev"
  homepage "https://gitlab.gnome.org/GNOME/libgudev"
  url "https://download.gnome.org/sources/libgudev/238/libgudev-238.tar.xz"
  sha256 "61266ab1afc9d73dbc60a8b2af73e99d2fdff47d99544d085760e4fa667b5dd1"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_linux:  "87a74706d570f25e40cec26c3ab07258b0b7e1b99950927d14083310f6998869"
    sha256 x86_64_linux: "c1e3053f6df286a07df2a34c82054fabb56af45680102943a5e459d12cc94cad"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on :linux
  depends_on "systemd"

  def install
    system "meson", "setup", "build", "-Dintrospection=enabled",
                                      "-Dtests=disabled",
                                      "-Dvapi=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <glib.h>
      #include <gudev/gudev.h>

      int main() {
        g_autoptr(GUdevClient) client = NULL;
        g_autolist(GUdevDevice) devices;
        client = g_udev_client_new (NULL);
        devices = g_udev_client_query_by_subsystem (client, NULL);
        g_assert_cmpint (g_list_length (devices), >, 0);
        return 0;
      }
    C
    ENV.append_path "PKG_CONFIG_PATH", Formula["systemd"].lib/"pkgconfig"
    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs gudev-1.0").chomp.split
    system "./test"
  end
end
