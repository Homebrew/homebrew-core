class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  license "LGPL-2.1-only"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.1.tar.xz"
    sha256 "f19e35bc4534963127bbe629b9b3ccb9677ef012fc7f8e97fd5e890873ceb22d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Avoid crash when non-UTF-8 locale is set:
    #   https://trac.macports.org/ticket/65474
    # Fix merged by upstream via:
    #   https://gitlab.gnome.org/GNOME/gtk-mac-integration/-/merge_requests/6
    patch do
      url "https://raw.githubusercontent.com/macports/macports-ports/a7f8a7049bb8e5c37a3a646bc216c5ab9244d9f6/devel/gtk-osx-application/files/patch-locale-gettext.diff"
      sha256 "af8a00c278110c4ad47b28b05e86d1a41531f764266d87d5cd843c416c7f7849"
      directory "src"
    end
  end

  # We use a common regex because gtk-mac-integration doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-mac-integration[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "f59ce737b0f88f41843b30e34d87c58769e99e2f0d59d217d9ddefecc7b2d4db"
    sha256 arm64_sonoma:   "b538f4f624bda8680cf08cd1a26a41f3dd8e0d16c4c52db4543a737554c068a2"
    sha256 arm64_ventura:  "f134dfb863936707bcf6927e9fcba8c50fee3faed9084e0fba72b1f7f8352df7"
    sha256 arm64_monterey: "581818e7d81cb28e844189d94bea6bbd186f166b32bfd36991bc37b662946ab9"
    sha256 sonoma:         "3d573ee5e2cab82e9c8ae0ca90facc8f075ad2c18395212c13f8d2f60456dcb9"
    sha256 ventura:        "88b5528e911a68f5eca6bd83b5a6bb2ba64cb34fff84875199762e13a29ff65d"
    sha256 monterey:       "1c3c9b3f0d821b0bd56ba6dac705e5f3024fbea667249c00fa69273e1f235a5d"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtk-mac-integration.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on :macos
  depends_on "pango"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"

    system configure, "--disable-silent-rules",
                      "--without-gtk2",
                      "--with-gtk3",
                      "--enable-introspection=yes",
                      "--enable-python=no",
                      *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gtk-mac-integration-gtk3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
