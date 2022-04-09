class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.72/glib-networking-2.72.0.tar.xz"
  sha256 "100aaebb369285041de52da422b6b716789d5e4d7549a3a71ba587b932e0823b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "f6c4a13ec7563d1571e52950f0b93ee71b0b463898509b7fe4710b7afd9dd472"
    sha256 arm64_big_sur:  "ddc66736ac03cd391e75089bae25f94672d8144026a2d270d95a696245fa6ee1"
    sha256 monterey:       "c23aaf5bff245462e0fd2176d15df17fd1c49244f49a3f290b0deeae791da2b3"
    sha256 big_sur:        "cd11ebc642a0660a726131579cf6b5bcceb86496ae55f641bc5a5fc9afb1840b"
    sha256 catalina:       "74649e42fae22c69aea564dca13b6c047e0b4b9d8df965e57d0614c46118f858"
    sha256 x86_64_linux:   "8e13ca5733c1d5e9948edcba67dc09683fb4d82dfc627f88838ca7fa6cf6705e"
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
