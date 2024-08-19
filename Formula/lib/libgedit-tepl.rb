class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.10.0/libgedit-tepl-6.10.0.tar.bz2"
  sha256 "bfaf68a4c81b7e32ff69d102dad1d656c49b5ef8570db15327a3c5479c8c3164"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  # https://gitlab.gnome.org/swilmet/tepl/-/blob/main/docs/more-information.md
  # Tepl follows the even/odd minor version scheme. Odd minor versions are
  # development snapshots; even minor versions are stable.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b433544a25b334a3fc1d7e788cf8d49e99637390ff7a09ef5693bf366a3a95c2"
    sha256 arm64_ventura:  "49875c169b846727b8ac55463a86dcbb3b938c12063e9f14b2557901fde3f59e"
    sha256 arm64_monterey: "afe0dc300dee8af11b6d30b9ce59dc5790b0b9161fcf499138725b9088ee576d"
    sha256 sonoma:         "968456ec7238409108ecf38183c5829855dcc33324605a4201b1081f1c76d93c"
    sha256 ventura:        "9fbcbec04391c9acea8794cb736ad4a126644dae87f7a8e9208eb67f71c85806"
    sha256 monterey:       "78f7e1fdd9fc27ef949c4487704d0d482b146f352c96b36958e4382fd405675e"
    sha256 x86_64_linux:   "aa06267843aeea879d9aacf3f4415f36650fed599ad25927444d3d16f84b0b8f"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libhandy"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
