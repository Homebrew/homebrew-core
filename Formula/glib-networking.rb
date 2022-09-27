class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.74/glib-networking-2.74.0.tar.xz"
  sha256 "1f185aaef094123f8e25d8fa55661b3fd71020163a0174adb35a37685cda613b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "122bad838a47e2b12a3259e5f6f764530ce1f9192bd5d723b0797a980f59d230"
    sha256 arm64_big_sur:  "73846a3b6be991682aa9488ca52085f2c9eeb10e2741c89b0a4713138b126a7b"
    sha256 monterey:       "0baf3a6c89945c9eee05388120593f1fdb6029941aa19d69d97126c2ea0de95e"
    sha256 big_sur:        "c4144d6bc2df863c2a78b3023c5018fc18e6aa3ee3af52d753e7b55cb38863bd"
    sha256 catalina:       "3f2b52595730bd9f18ea97c6413583ffe5cbca90817711cec8fd70d20cffaada"
    sha256 x86_64_linux:   "e9dea426a3cf1dd6ce4ea427a505087b8d188b0cedd56b3fd75c1a1757575090"
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
