class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.7.tar.xz"
  sha256 "4be15202ec4184fce1ac15997ece5530d2be32fe9573875aeb10e3b573858748"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "432a1a5516773598e091d855d0ea1794d18465685c8b0c7bc634b0298440fb19"
    sha256 cellar: :any, arm64_sequoia: "ae0b1cb150777c646427142e8b1c1bee766e0494a2dcb57304d56ce2fc4d96a6"
    sha256 cellar: :any, arm64_sonoma:  "a3d7d0aa240cc2e3239448a84b2345b6e92dd5992e40be29e66b916a2c7a34a0"
    sha256 cellar: :any, sonoma:        "c5f342a40d5eb2daea339a3321f600e0fe134926f51ecb13b18022727cd2f0fe"
    sha256               arm64_linux:   "6964c240d0cbcd83d519a48cb96773fe9537374c35324f5e2cc1ca8451899a53"
    sha256               x86_64_linux:  "0fbf7d4e76fec144b95d570657b493bc41d4cac2cab6482038455f35b7ea9f43"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "gdk-pixbuf"
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  # Do not include <gio/gdesktopappinfo.h> header
  # on the platforms that do not support it (i.e. macOS)
  # https://gitlab.gnome.org/GNOME/libnotify/-/merge_requests/53
  patch do
    url "https://gitlab.gnome.org/GNOME/libnotify/-/commit/13de65ad2a76255ffde5d6da91d246cd7226583b.diff"
    sha256 "243f8b03abb80bbd9df9d69f4883ee249b44d6260fbf7bc2e54c9f612f478c59"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %w[
      -Dgtk_doc=false
      -Dman=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libnotify/notify.h>

      int main(int argc, char *argv[]) {
        g_assert_true(notify_init("testapp"));
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libnotify").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
