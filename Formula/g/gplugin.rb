class Gplugin < Formula
  desc "GObject based library that implements a reusable plugin system"
  homepage "https://keep.imfreedom.org/gplugin/gplugin/"
  url "https://downloads.sourceforge.net/project/pidgin/gplugin/0.44.2/gplugin-0.44.2.tar.xz"
  sha256 "aea244e1add9628b50ec042c54cf93803f4577f8f142678f09b91fd4c0b20f72"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-3.0-or-later", # gplugin-gtk4-viewer
  ]
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/gplugin"
  end

  bottle do
    sha256 arm64_golden_gate: "444084d0e2b25d9088641720198af1423a90cff379c38f909f5c8642be4cac5c"
    sha256 arm64_tahoe:       "6d1d80f0dc36842a0ef0da3a9fdb451262ba137a2329bbf6067d082632c0ce67"
    sha256 arm64_sequoia:     "8a27d17e42bdbc85ea211bba75a90d4e3476526c1cfd9b391fe0376f9694ca84"
    sha256 arm64_linux:       "ddec0cec4f6e999b86bb57792fc864ead1cfe735ae27d40cbcb2ef1d5bfd99da"
    sha256 x86_64_linux:      "94c4c9f43d152d8a5a5faa4bf647fccd1f4b802292e4ced60befb78947a8bb45"
  end

  depends_on "gobject-introspection" => :build
  depends_on "help2man" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pygobject3"
  depends_on "python@3.15"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddoc=false", "-Dlua=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gplugin.h>

      int main() {
        gplugin_init(GPLUGIN_CORE_FLAGS_NONE);
        GPluginManager *manager = gplugin_manager_get_default();
        gplugin_manager_add_default_paths(manager);
        gplugin_manager_refresh(manager);
        gplugin_uninit();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gplugin").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
