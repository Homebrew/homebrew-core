class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.72/glib-networking-2.72.2.tar.xz"
  sha256 "cd2a084c7bb91d78e849fb55d40e472f6d8f6862cddc9f12c39149359ba18268"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "fbc0700a8096cd5e20631902b64774999695720ab99c53d66e139c7e2da9b927"
    sha256 arm64_big_sur:  "acdee0913dd6d67c5f30a017c425e1c71bfc122efe0e1eb79df68a687bfb4a52"
    sha256 monterey:       "0fa447e719052aba6e469535c71697abaff68d917231007ad3c706cf8f5d8ec8"
    sha256 big_sur:        "eb42c407a8a2826810e2853631db8b2915219f1b813c1889daa167d4c9f2f136"
    sha256 catalina:       "03df2e2d787a1827abd1ac102cac2b4f34f7ab3628ba9be549dd87ee02590d6e"
    sha256 x86_64_linux:   "963497f3b55d5f4684e0948ca513a9bb9cf30094ef27257ad9ef220538a82f45"
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
