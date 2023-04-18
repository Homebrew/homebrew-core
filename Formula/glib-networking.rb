class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.76/glib-networking-2.76.0.tar.xz"
  sha256 "149a05a179e629a538be25662aa324b499d7c4549c5151db5373e780a1bf1b9a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "de464bf8478322901fc341eddc921b165bb8f87b8ed3da9e28b56515bd84fecd"
    sha256 cellar: :any, arm64_monterey: "f9b3dced728d6dbfaee81bf6c52812903f0250b07e81cefe9e4951badd7cc5b7"
    sha256               arm64_big_sur:  "835dcf53567cdee2eda8142852f6c0b18f8997e94132f5a65a720d653a8d411c"
    sha256               ventura:        "a12a52068b3b519d91fb3a436d749033f7eb6ff52573f0de93874fee51b60b95"
    sha256               monterey:       "d7abe5b3612978d64efaa8d5142c515a866b4008b11571e7025377b540860d0a"
    sha256 cellar: :any, big_sur:        "b062ba299579f25ea85542e61c4ca55b1ce4a549290dc02d03e31a4bf4ec5b2d"
    sha256               x86_64_linux:   "0157443826842a25f1d608dc13e75470ce631a3664f59dc04e520436079eefe6"
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
