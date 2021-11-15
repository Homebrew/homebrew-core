class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.70/glib-networking-2.70.0.tar.xz"
  sha256 "66b408e7afa86c582fe38963db56133869ab4b57d34e48ec56aba621940d6f35"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "08c801c005aa171ce6654a3a9ded3030b781a43eeb9dc719e8685d756ec13ce2"
    sha256               arm64_big_sur:  "ba522c00fb66cdecb8ffd2a59097d40442e0d4855448a0ec35fa930511ecccb4"
    sha256               monterey:       "c115eb3ee607478945b79058c22e63545b8f9cdcdfe750f3279f34d47f35a6c5"
    sha256 cellar: :any, big_sur:        "eab028e138ec9fe2017f9dcf052c09469b906ccb2e5b147572487cacd9061777"
    sha256 cellar: :any, catalina:       "a7002f6e071a68e70a0d5af8377bdcf4c9ab6f9606272cb94b94aaa0ce8a3be8"
    sha256 cellar: :any, mojave:         "5a48d3f2012eb407b90c38ae8db334d516b53ec5d8127f58bac4ed2a571e09af"
    sha256               x86_64_linux:   "ca7db942c847b82b7115b770d585ce8bf6791e0e09a0f06cdce9b47f8eeaadea"
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
