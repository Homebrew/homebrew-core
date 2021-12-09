class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.70/glib-networking-2.70.1.tar.xz"
  sha256 "2a16bfc2d271ccd3266e3fb462bc8a4103c02e81bbb339aa92d6fb060592d7bc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "76cd80fd1d44e98d7ae336ddaa8432ebfeb7945e1a26f455cbc3ac9bf8d2b7cd"
    sha256               arm64_big_sur:  "6d57299e3d64fa72e240c7a6e44dcd8d4cc6e52dac92dbdae3079b21f8b0a855"
    sha256               monterey:       "eee434d7618275974f043c5e01977f38454cf0dfa63bf571aa46bfdbf7f3f05d"
    sha256 cellar: :any, big_sur:        "927ee5f7047d99fec9c63f99c25880f49d8beedc656d90f7bfc05ae87b008d90"
    sha256 cellar: :any, catalina:       "97038458e6c21970e47874cf70e2e3a6653af04f29cc4ba30ec11d5991fc582d"
    sha256               x86_64_linux:   "0f62924fba56a4b03f7a278f837224cea8b75acbcc315fe3192924f3aeaacd74"
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
