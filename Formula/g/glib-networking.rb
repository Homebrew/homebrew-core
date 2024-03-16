class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.80/glib-networking-2.80.0.tar.xz"
  sha256 "d8f4f1aab213179ae3351617b59dab5de6bcc9e785021eee178998ebd4bb3acf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_sonoma:   "b0113931d5c29854323aca05a1f17f6012d5f4d361b224b5d1e7cd88cd661af2"
    sha256               arm64_ventura:  "4be43cfeeaf350920f488b244e2e58d93e693b6c9eb80dc98fe81ad5c238691c"
    sha256               arm64_monterey: "875000000ae24f17c7af3ca719c810ed4a93f5c2ae5e59d0e55ff062adc2ab72"
    sha256 cellar: :any, sonoma:         "f99904b22b903c739fd5eee735a3fbb305d2b21c911d91a17f4d65a0a33933af"
    sha256 cellar: :any, ventura:        "d342c2811b5bc90512a0cb965d5828d9ae3fda4bc6debdf9cda8073e86c363aa"
    sha256 cellar: :any, monterey:       "dda0936ad953403b2af18aba9c915e89d13d6e8ad3b91c66c1bb240b310fc78a"
    sha256               x86_64_linux:   "d3908022c8c471921a69f9b74f81b05821d356647490e1b60212decb2ebd4af8"
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
