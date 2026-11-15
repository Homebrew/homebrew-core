class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.9.tar.xz"
  sha256 "c906bb084027ea512f94a60fbfc0cc8d4f17e4b4d525bed370d07a6d8714c923"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2eb6e99dd9d15ee38593cdd68239c88165e7ff5a132c35a2767fff539c3bb190"
    sha256 cellar: :any, arm64_tahoe:       "17d27073f8693a48fcb06242b0cf2f95f387c59ca1cdea34ba6f7ac6c37fcd2e"
    sha256 cellar: :any, arm64_sequoia:     "d996e1c3ff28aa9f40862aae4c4d38cb21d1cc9c56acc5cadb784e351e8f0991"
    sha256 cellar: :any, arm64_linux:       "75d318b4a27ed7deafeec4debcd00bb1a6795be0ddc866fc799bd9e1aa86d661"
    sha256 cellar: :any, x86_64_linux:      "c2bbddebc2cb10170c95fb511284b39300a8cfc5d2e7e872bc2a8b2305b9c94f"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "gdk-pixbuf"
  depends_on "glib"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %w[
      -Dgtk_doc=false
      -Dman=true
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
