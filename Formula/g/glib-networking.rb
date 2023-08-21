class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.76/glib-networking-2.76.1.tar.xz"
  sha256 "5c698a9994dde51efdfb1026a56698a221d6250e89dc50ebcddda7b81480a42b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_ventura:  "b46b561fde550ffbfb0df6b595d7fe0bca4a229f40a4c4699c477dd9e849ca24"
    sha256               arm64_monterey: "b6a9d0be29ffade351cf046ca88cba0e03c5369619b7bae442c2b0fd0afb189a"
    sha256               arm64_big_sur:  "ffa74c49e8137e37669f528d9bec9465dd23eb7de6311c7a9ecfa60a337d5873"
    sha256 cellar: :any, ventura:        "f1bb61332f7ae0237b407816b1819e790bed26a8792dca707709e9bd72d03183"
    sha256 cellar: :any, monterey:       "bb9ad5daa35cb8aae15686a43464fd6fd454d408a7f66accb3724eef5c5e3a95"
    sha256 cellar: :any, big_sur:        "34d39743f460d9cfc4264279c5d20df69013f2d83898866464ad64137e067e64"
    sha256               x86_64_linux:   "e81ab5a6b5937ba61990e2ddd281295f1573b3bfca49590b90ac62503a149ace"
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
