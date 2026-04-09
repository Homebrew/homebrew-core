class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.80/glib-networking-2.80.1.tar.xz"
  sha256 "b80e2874157cd55071f1b6710fa0b911d5ac5de106a9ee2a4c9c7bee61782f8e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_tahoe:   "4529f9f2580208ce7fc05c8246fe2204e01dfcaa4a5449437297bce2bf2cbe55"
    sha256               arm64_sequoia: "3a602d6d04b23f9ea7e3220f9d15f3665df3effb3e23755647ddc37290043851"
    sha256               arm64_sonoma:  "f4dbd6b6633a8e45f1290c90fd6e97a9ee60e2e0553cea6ff174d8c817beee7d"
    sha256               arm64_ventura: "f9907f3da38a5bee59b1a5b8dd794c2fa761595befc27c7f9c1abcda599c6275"
    sha256 cellar: :any, sonoma:        "42ed98bed547bbeae647d95e0b5f0da4a85e7416cb722efbc4a6e9f975c1bdf0"
    sha256 cellar: :any, ventura:       "051b59d9c1a7d2403a8d34628d6c0acad7c25f50e9d25d4756095c998975e128"
    sha256               arm64_linux:   "151f752cd064606506e02b137a07b5a40aadb3a1df99ac5849b65e0eb83f3063"
    sha256               x86_64_linux:  "c20490896cab94dc36f83a54bb58ccefea822fb311c03de4a5624e34b09c68ed"
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

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
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
