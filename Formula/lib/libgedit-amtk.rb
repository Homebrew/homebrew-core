class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.9.1/libgedit-amtk-5.9.1.tar.bz2"
  sha256 "2f7d5da4d42821965f096b2a66d8b5b5f8d7d76705fd23a907de160c995d35f4"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "c6afbf2a294bb479782b425c6b9bf7258b0cf38031652aa8031dbb3ba32a2778"
    sha256 arm64_sonoma:  "6c9760110e1cda5406ff084d6ce38622e14bfa203147b7f3cf8927f4e8c21d71"
    sha256 arm64_ventura: "ec1031d95d3f32843a0020ff64017a23107ebad3d7d58560994be02dd1eb59ee"
    sha256 sonoma:        "781ca6310c4334487c1378c6b733506584f878031c609965b99066c7b3036597"
    sha256 ventura:       "715abfe98dd941d44bdca2d019a812441b331630900587f23e34319ec43e477e"
    sha256 arm64_linux:   "c5731b9794e4745995351ceef4bc7dbcb243e46d008510f6b18947edfe04a9b1"
    sha256 x86_64_linux:  "27205ec858d8f5f8af6325219c3b4fa8a851e30183e8ece633a5cad4840301bd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-amtk-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
