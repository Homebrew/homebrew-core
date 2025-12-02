class Gplugin < Formula
  desc "GObject based library that implements a reusable plugin system"
  homepage "https://keep.imfreedom.org/gplugin/gplugin/"
  url "https://downloads.sourceforge.net/project/pidgin/gplugin/0.44.2/gplugin-0.44.2.tar.xz"
  sha256 "aea244e1add9628b50ec042c54cf93803f4577f8f142678f09b91fd4c0b20f72"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-3.0-or-later", # gplugin-gtk4-viewer
  ]

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/gplugin"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "1467d4fde4bc7c78346be7deb8b19f52e9156a61e8ea10b1a4fa039655b91b5d"
    sha256 arm64_sequoia: "8dff32d0e5254a4294dd37bebb9a0a0509dbf43c4c561e5a284658ea494f464a"
    sha256 arm64_sonoma:  "b56fe145940fef1e132fba6fdc4ebf539e6c012f24db6750565bbee7d1612e91"
    sha256 sonoma:        "953a1cb35fa6b589eb49ea1f4edb1215589dccf2300aaa1f2e03d8cd1a70106f"
    sha256 arm64_linux:   "97dc4205707191b92658c1f032bd9ab0da11e22c2ca01595a21c09cac788f0b3"
    sha256 x86_64_linux:  "73f8fcc1f1394eebe3ca2507eb7f23cdce65af4138c7007042ff4dcbd2257dfa"
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
  depends_on "python@3.14"

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
