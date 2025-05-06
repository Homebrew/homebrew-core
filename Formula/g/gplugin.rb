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

  bottle do
    sha256 arm64_sequoia: "09e5e444bf267a554d99cbc4c49ae715f4394d394a89262198d5b9235adf0eb4"
    sha256 arm64_sonoma:  "4bd6796d1074b0eed0f3e246359c0b2987da4bd4b1f9f3925276b0691a64c6b5"
    sha256 arm64_ventura: "21e131faa33611a69519060d2433b4ca1d88f3901da4751eda61fcb79b0e2e8a"
    sha256 sonoma:        "71372c15d4e29b7d3fced3398e787b2ecd7ef3195d4c6322188061d39b1c1989"
    sha256 ventura:       "de97051eecd1d1afd97940320e6bc0211ea5925d6eaaa9566b5b8ef6e5a7d8ad"
    sha256 arm64_linux:   "1ef59efaa287d5797c00b02c5cca61d55f369e21f9d1aca442927057f516813c"
    sha256 x86_64_linux:  "c4c052010de643592350835459ec790cbb2938b29743169bc4f51bc42b430e62"
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
  depends_on "python@3.13"

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
