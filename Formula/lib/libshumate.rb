class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.0/libshumate-1.0.5.tar.xz"
  sha256 "a8cfd8df9177ee44b04733b017af13c9e93f98765cdc89b750a48edaf701956c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8ace2302e532deed3abef6820cba7e7368ad91e16f81365c61c5154f9a631df6"
    sha256 cellar: :any, arm64_monterey: "dcfbdf45f68987722fda392b4493bcc0d7ed8022946b95d330ca1080f81f34a8"
    sha256 cellar: :any, arm64_big_sur:  "00e3700063d70bbdba9e6c1eebedbdf655af0d46ab84d381a682a35fe65af287"
    sha256 cellar: :any, ventura:        "9df2b472770fad1ff4bdbd16769f2643a42136540c6e65a685d78be0ed63a601"
    sha256 cellar: :any, monterey:       "bbf3f722b9e61d2acbc25d6084deae711fe9d8edc3fa0ed24d4a45831e418402"
    sha256 cellar: :any, big_sur:        "8fba9a912519736b61d1c098fe599162e5160fbd2d16aa168abb4b03478f74da"
    sha256               x86_64_linux:   "3e41bfe9170cf5673b2c8cd73e9c3b7e488e9f73318a5ef2bc31bcddc193cf21"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "cmake"
  depends_on "gi-docgen"
  depends_on "gtk4"
  depends_on "libsoup"
  uses_from_macos "icu4c"
  uses_from_macos "sqlite"

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shumate/shumate.h>

      int main(int argc, char *argv[]) {
        char version[32];
        snprintf(version, 32, "%d.%d.%d", SHUMATE_MAJOR_VERSION, SHUMATE_MINOR_VERSION, SHUMATE_MICRO_VERSION);
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs shumate-1.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/shumate-1.0.pc").read
  end
end
