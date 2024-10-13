class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.80/glib-networking-2.80.0.tar.xz"
  sha256 "d8f4f1aab213179ae3351617b59dab5de6bcc9e785021eee178998ebd4bb3acf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_sequoia:  "3d424d6b858a6c4f66d44e51822d375a177c6e3f0b3c42a183c20037abd195ea"
    sha256               arm64_sonoma:   "30b0bc73d7307c7c10eefefdab0d4e5cbada6062d3af70e87eda5cae0d384078"
    sha256               arm64_ventura:  "77eaced4c03965b9708daa421f20d056f12e7bbf86b29d48aa5b942fe429d557"
    sha256               arm64_monterey: "afda408dd3bcd96460597c803669eff4e9c9bf435c2e5201f5b7f20e0295d8c4"
    sha256 cellar: :any, sonoma:         "c317dcff3c617af81233d1d14402f37142d2e30977349d700ba2b8246b4f2b91"
    sha256 cellar: :any, ventura:        "e4f6a66cbd7b69a095ac7bdc13ebd23cfac4553ccbe954629d0c935c28164f6d"
    sha256 cellar: :any, monterey:       "5f7a104feb68e3b2177090774108af661129297f194f84a3381e90a007d793c0"
    sha256               x86_64_linux:   "b50d23dcdaa8cf997507be5876edc09b0f5afc0639a75051a4c738e1995f40ff"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
