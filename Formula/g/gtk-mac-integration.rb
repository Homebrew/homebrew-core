class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  license "LGPL-2.1-only"

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.1.tar.xz"
    sha256 "f19e35bc4534963127bbe629b9b3ccb9677ef012fc7f8e97fd5e890873ceb22d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
    sha256 arm64_sonoma:   "85cd5c0a85e3e5dd6eb25fc472ff8bca8904dfe6e2d5c008cf94707979780b50"
    sha256 arm64_ventura:  "9074e95f28068dc78a191df93877127a01cf4670bb9ccdfe9146e54a0ff7c0d9"
    sha256 arm64_monterey: "26d230d66f0a6900e8590fbfa6a6d77fee9b1d42db18a48b457ede3c9fab8485"
    sha256 arm64_big_sur:  "7151adc39408f9e6b22706c623c2d16f444612e767c6eaba59b0c40f87a0d05d"
    sha256 sonoma:         "25c3fecf35f2b447f160fd4b8e5e1434c816a04d2fd6c3a5cc0c3d0163deafe9"
    sha256 ventura:        "3f91d9bc293e808976fee70d4dcaa622a0fdb7b14592679f9b8947c13a741e5b"
    sha256 monterey:       "802ed17bc9f4420482938c98e2ddcfdcd7b08f77dc56e99d06f1116ac06c974b"
    sha256 big_sur:        "2cf4342b7faedc47562f7b5a1dc6215b9255833e7bb71e23d6bcddd01deac89d"
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
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on :macos

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-silent-rules",
                      "--without-gtk2",
                      "--with-gtk3",
                      "--enable-introspection=yes",
                      "--enable-python=no"
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
