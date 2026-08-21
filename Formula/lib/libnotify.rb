class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.8.tar.xz"
  sha256 "23420ef619dc2cb5aebad613f4823a2fa41c07e5a1d05628d40f6ec4b35bfddd"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "668a377fae94a6562e98b1d66786417d41fb0026442995262d5b6142090cd06d"
    sha256 cellar: :any, arm64_sequoia: "a911b9312b4c1cf01f9906c95c75f4b9298d92172f00732f8ab4ad1467983349"
    sha256 cellar: :any, arm64_sonoma:  "6d462a1db3c40bdc532a3f7b4ef2585a585938445c84fc6362055416bfd5d6c7"
    sha256 cellar: :any, sonoma:        "0ea64c170cd514761100480749196bb5b42407af35e6c3a9e5e608d6b629607d"
    sha256               arm64_linux:   "c319b8b7d0b49559e2167fb0413f8c207dffc14b7d31a5bb3c6e1f189cdddf48"
    sha256               x86_64_linux:  "38ec72fa936aaffdaef6293c61cd029f0347f9e1f3d1b242b7f6238c8c7170be"
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
