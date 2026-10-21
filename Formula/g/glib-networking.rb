class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.90/glib-networking-2.90.0.tar.xz"
  sha256 "83a75e3d9c36b66ee86d3281c2fc997816101968a5126ba322b2acb9a74dd8c0"
  license "LGPL-2.1-or-later"

  # This regex is intended to avoid the `Gnome` strategy's version filtering
  # logic while maintaining the "even-numbered minor is stable" behavior, as
  # minor versions >= 90 are still stable in this case.
  livecheck do
    url :stable
    regex(/glib-networking[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256               arm64_golden_gate: "da4332ddddfe5a14ca664b4b851622c6e74899e1c7ec2ceab51017b7628b037a"
    sha256               arm64_tahoe:       "06c8af940e885e2b499184444d4fd98c7e343ba1dd80ae4c1bcc0e85963d3eb9"
    sha256               arm64_sequoia:     "9d437295eb3e4af595b0f3722d2733e9659ee764db9fa275004a0b29282112ce"
    sha256 cellar: :any, arm64_linux:       "716a983f9c64c1f5901754aa2962c53d284ae859ddd3e9ab3822324e59a9a479"
    sha256 cellar: :any, x86_64_linux:      "4cb5837be1c35bf7b2f59414e67465425f96efa3019b78639fc06543bca4bd1c"
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
    run "{{HOMEBREW_PREFIX}}/opt/glib/bin/gio-querymodules",
        args: ["{{HOMEBREW_PREFIX}}/lib/gio/modules"]
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
