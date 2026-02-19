class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.8.tar.xz"
  sha256 "23420ef619dc2cb5aebad613f4823a2fa41c07e5a1d05628d40f6ec4b35bfddd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8ee57b001510f29334c55080553cf34f41b9e8643484429ec1a0d4852f9fb58"
    sha256 cellar: :any, arm64_sequoia: "4081e1a50cd23929e7c1ae070e81bf2dc85e6099a274d4e1b98a60da459d0cb6"
    sha256 cellar: :any, arm64_sonoma:  "2f5cab371969079dbee0c140accfc7a3267bbf006c63e3a1935c153fde4033a7"
    sha256 cellar: :any, sonoma:        "43ec242ea169e80dda511f44370f9df94f2f50d0996a60149f236c9bbcc515ef"
    sha256               arm64_linux:   "30a82c884d084884e6d52521fd84aa30c4192e60bca5756b8973a4a786280cf1"
    sha256               x86_64_linux:  "8a89fcc90b7fc4b1a4559cadd439c9565ea597d4b6184125eb7e17ece817e483"
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
