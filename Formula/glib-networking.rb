class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.68/glib-networking-2.68.1.tar.xz"
  sha256 "d05d8bd124a9f53fc2b93b18f2386d512e4f48bc5a80470a7967224f3bf53b30"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_big_sur: "58be10c17da1a361a5f98a5525ff33967d2d17df212e14b622cd1effd6449dee"
    sha256 cellar: :any, big_sur:       "22288b8ad200b43cc6e6be824457e7d078425aeb9d3c9992a60b7f98bc1d8780"
    sha256 cellar: :any, catalina:      "cf152dc56f935513958b8807d4a8c7f02b9e6950110ce66609f54df5bff0da59"
    sha256 cellar: :any, mojave:        "0e4b6128e863ec39780f0750a5057a90013780c47b2438d25b30e4effbbe3609"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  on_linux do
    depends_on "libidn"
  end

  link_overwrite "lib/gio/modules"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args,
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
