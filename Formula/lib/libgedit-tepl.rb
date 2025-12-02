class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.13.0/libgedit-tepl-6.13.0.tar.bz2"
  sha256 "5d738ca56ae31facba0d88b0a2e406b2507a3dc95f75bfb9f509ff4b2a9d20d3"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3d33602566304cba343126a66f48ecc48dd8d54acdd76230ff931241b8f4c708"
    sha256 arm64_sequoia: "94194de48f116827482b16d113a81c39b5908c3267773ec5324a4d9d6ef1f448"
    sha256 arm64_sonoma:  "526084766627985fa78b62c872c0e2987143cf34842a26e8d1d703b3f8508a81"
    sha256 sonoma:        "b119ef2c01501eb2b49a55eda604806a86e66b0ed23a0fa6033d9d5b70cf44a4"
    sha256 arm64_linux:   "a1c122d9a063796951e49da0ef86e5b37de73bfe9c2982339239c6e391448b61"
    sha256 x86_64_linux:  "d2dd4bdee96cd5ecc5589579e98f7c6affbc63308cbd880fee28a73217ec00b8"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@78"
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

    # `pkg-config --libs libgedit-tepl-6` includes icu-uc and icu-i18n but modules
    # are from keg-only `icu4c@75` so pkg-config needs to look in the opt path.
    # TODO: Remove after https://github.com/Homebrew/brew/pull/18229
    icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
    icu4c_pc_dir = icu4c_dep.to_formula.opt_lib/"pkgconfig"
    inreplace lib/"pkgconfig/libgedit-tepl-6.pc",
              /^(Requires\.private:.*) icu-uc, icu-i18n,/,
              "\\1 #{icu4c_pc_dir}/icu-uc.pc, #{icu4c_pc_dir}/icu-i18n.pc,"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
