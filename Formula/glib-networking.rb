class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.74/glib-networking-2.74.0.tar.xz"
  sha256 "1f185aaef094123f8e25d8fa55661b3fd71020163a0174adb35a37685cda613b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c22fa8ab4004584fe047a957a78669de9a5e379ef97e543486f083d79e5f580e"
    sha256 arm64_monterey: "87daff64339dd3b65b69fff4cbab5b416bd7af562629d2efd74dda23ed3f164a"
    sha256 arm64_big_sur:  "e7746e5130b1b2acbefeed67c358c404469ffe936f8ea6fb9246f787b87156df"
    sha256 ventura:        "eed2ff2cb8c8f1254128a96078d7ccb24e1ecc0dc89455b18d0ce7e438e0fabd"
    sha256 monterey:       "45cfef96fdb0f052d437aa9bbff0d7690fdd7bb6f0176ec6485086d7bbaba1c1"
    sha256 big_sur:        "72acd8e5bdfb0742fa8c2d4a7b4f559b1ae384ad31459bf7190abc82e6484adb"
    sha256 catalina:       "15216a8836cd1fb584f653de86f1de693f917727eec51ca55bc7a40eb0d55181"
    sha256 x86_64_linux:   "d466490a0c4bb6adcc338b3fad485bc25ad7d906eb1096f24b10d916859ce60d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  def install
    # stop gnome.post_install from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", *std_meson_args, "build",
                    "-Dlibproxy=disabled",
                    "-Dopenssl=disabled",
                    "-Dgnome_proxy=disabled"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<~EOS
      #include <gio/gio.h>
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
