class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.12.0/libgedit-tepl-6.12.0.tar.bz2"
  sha256 "2170a6db99803b08fe7437bd8382ed2938baf4f5838349ba90dee1308a7dc08d"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "3bd2190b0dc85fa95f6f54efb237fae81c8f8b85c536d963c8d908921be66982"
    sha256 arm64_sonoma:  "b274c179ab02621eaa256e26e6fcb41ccfa8eb0802ff02fbc4d28be925d7fa30"
    sha256 arm64_ventura: "9c072da54b10399e2419a09f0a77c379ad078b99cb3bc469b4b436d82cd5140e"
    sha256 sonoma:        "5adc56a4593f5a01a32579662820fe48d5304beae43071c72c93d33131ecfb7c"
    sha256 ventura:       "df23620dda9571a0de98491dd967fd3e7b70a506df45037f2e9804a78c344918"
    sha256 x86_64_linux:  "ad6912a898e0df486baf1927c24db4092293a826f951c38724435d0340ea458e"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@76"
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
