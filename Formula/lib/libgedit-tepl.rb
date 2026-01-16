class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.14.0/libgedit-tepl-6.14.0.tar.bz2"
  sha256 "2b695f41475573aa59f1cd004b5cc3d2021d0444decf26eb8d38864348fb3577"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "989c5236c3b916bfd20e370fcf138c38a1776aec386a09f7c70a31697f4bde43"
    sha256 arm64_sequoia: "12f2b6d635b9fcbbfec6a76a9f85da73671e61e8638756e9b401a5ca55b3ca82"
    sha256 arm64_sonoma:  "a79191f3be5bad30d220cf495dfe58430eeddeb64fb81e56ea76f70d57ac80a2"
    sha256 sonoma:        "9c74fb0ba2ae89e2a709c7d782505a6032683726d4d906e65ed00799d8dc74e3"
    sha256 arm64_linux:   "cfbe37f911dbed80978ce37faa86d772e72539168ba1513e816446ee2ed99b06"
    sha256 x86_64_linux:  "e064295dc98803eaadf8fbf90436001fcd5089cf1785e0221a1e64837862f8df"
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
