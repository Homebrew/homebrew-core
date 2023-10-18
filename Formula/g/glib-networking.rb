class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.78/glib-networking-2.78.0.tar.xz"
  sha256 "52fe4ce93f7dc51334b102894599858d23c8a65ac4a1110b30920565d68d3aba"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_sonoma:   "a3083f7530e810fdf56d5ba6e1f4b86e9b5982a30984e8c28aca1999ed3adb1b"
    sha256               arm64_ventura:  "2a8bcf4a6c043f071fc979b7ddd324f484dadffeedef21a570b59d7200b2576f"
    sha256               arm64_monterey: "c23398d9a8b19176bd8605b5687f40dd020761249ba731526c38a1fb7043e8ec"
    sha256               arm64_big_sur:  "c2092ad9f0905d037464588813f8e833993e0a8c297fd24b6145b07c38d0b300"
    sha256 cellar: :any, sonoma:         "a8154d33e0cc488e7378f76e4e7c68992b9ae37db2fa618bf29061046fa48359"
    sha256 cellar: :any, ventura:        "8d45c1905c641b2cebaa6997bf5c194d481925e5313ef25534361b4fde198095"
    sha256 cellar: :any, monterey:       "ea4fe701f3bc87f9f248e507e0c354c7601b31dc298a0c2972fe5b759e949d6b"
    sha256 cellar: :any, big_sur:        "b90a3fd3f328c9decef3fd6e511f2fe64dded1d90b5432a54073cef5f902a68d"
    sha256               x86_64_linux:   "8f138e69272a1138385c07d8bd9c3af09c8543ae7faeb5f1abd05c049f7c270d"
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
