class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.58/glib-networking-2.58.0.tar.xz"
  sha256 "bdfa0255e031b8ee003cc283002536b77ee76450105f1dc6ab066b9bf4330068"

  bottle do
    sha256 "c63f6875382dd5a2f1f434f71ec37ebdd7901cf2f2c6241443c4bdea7b570346" => :mojave
    sha256 "848ca8306d7132d621325029270190bdfc1ceb4c27260ac1bb924a1d586f1bcc" => :high_sierra
    sha256 "fe7eee17a3d576796fb8201eed5e0957726fc5af4e08500b2fc443cd2b8d3527" => :sierra
    sha256 "4992ba80139c7bea88e579e24756b1c1793e0ff7f4cf30450123f405e0bc7e70" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "pkg-config" => :build
  depends_on "ninja" => :build
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
                      "-Dlibproxy_support=false",
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
