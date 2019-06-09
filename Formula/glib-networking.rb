class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.60/glib-networking-2.60.3.tar.xz"
  sha256 "d50183046a4ff955d8cc7e953067cdfc94f14dbfda3024bf377ff37a3121dcd5"

  bottle do
    sha256 "b34844abdf92db2676cc2970540da132317124b8f6b731da229ff977ab938131" => :mojave
    sha256 "d6881d37e95fd094528eca09c985a71fae6c5bf15a3c603ca5e90a6ba834ddac" => :high_sierra
    sha256 "deef0ffc928f9afc9ee81f4350f71edf683c36c01d95984eb50ed1b2759589f0" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dlibproxy=disabled",
                      "-Dopenssl=disabled",
                      "-Dgnome_proxy=disabled",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
