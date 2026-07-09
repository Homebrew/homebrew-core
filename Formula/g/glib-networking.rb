class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.80/glib-networking-2.80.1.tar.xz"
  sha256 "b80e2874157cd55071f1b6710fa0b911d5ac5de106a9ee2a4c9c7bee61782f8e"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "ae0e5bf817df76e53439bb005204453a44a1c142d0b0ee47cd5d6e789e2d7276"
    sha256               arm64_sequoia: "b2c118026358bc57f302b83f4e39784929b384d81ddff0b19dbd9c4c22b0c72c"
    sha256               arm64_sonoma:  "284f9bb9a95e69608868574a74b1dc89d70b84bfa97a8442793aa6896bb06d3a"
    sha256 cellar: :any, sonoma:        "96f9cc104e18a43db2842c092b198fc25d24ac0c218b3708830fd144bfcc1c60"
    sha256               arm64_linux:   "bcfcaf0897ca867f2970f6b09c826c6a38b7ea574d81faaaeb82a1d23437a13c"
    sha256               x86_64_linux:  "8aebdfee3449082444c36fc6351e6a2a331aa2d37f85c6caf55b0e519c6e0833"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  on_macos do
    depends_on "gettext"
  end

  link_overwrite "lib/gio/modules"

  def install
    # stop gnome.post_install from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dlibproxy=disabled
      -Dopenssl=disabled
      -Dgnome_proxy=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    gio_querymodules
  end

  test do
    (testpath/"gtls-test.c").write <<~C
      #include <gio/gio.h>
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    C

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
