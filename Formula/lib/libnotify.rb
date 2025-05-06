class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.6.tar.xz"
  sha256 "c5540aaefb60e1d63b1c587c05f2284ebe72ece7d0c0e5e4a778cfd5844b6b58"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ea69f7b5455c3a6541cf0860074b7b6e3e68e6bbb48c64cb4cc6221e6ce8dde9"
    sha256 cellar: :any, arm64_sonoma:  "ebea4c89f379ab596f73e8613cdb45085b91995f8ab225b22abc9143ef3418c6"
    sha256 cellar: :any, arm64_ventura: "d4c06f68f3f4fd97e56695bb166a806488f78ccd6d677d943d2a49bde302aef7"
    sha256 cellar: :any, sonoma:        "d6a909e188f2dff4caa76a5c8cdc1204cb8b8e6cf752cefb5dd8e25b19be774f"
    sha256 cellar: :any, ventura:       "75bab3ee807d8c9f36a039b973279f8e154bd29d9a2cbcf533141b82bced5450"
    sha256               arm64_linux:   "995dc473382763e33a51546b3ae69ba723c5cb5815e1a5f688f9c17e62ba9b42"
    sha256               x86_64_linux:  "f040cf5598067f5d9af35c90bd5df9520f5a3d422c78a1b0fd01c01ddcbee021"
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
