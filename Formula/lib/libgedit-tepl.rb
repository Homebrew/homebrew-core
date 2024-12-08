class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.12.0/libgedit-tepl-6.12.0.tar.bz2"
  sha256 "2170a6db99803b08fe7437bd8382ed2938baf4f5838349ba90dee1308a7dc08d"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "678a5bdfcf830bf74e36103aca8c06434eb7f96b5db670fcb6c321ea18e27ec0"
    sha256 arm64_sonoma:  "d152e02babcc63fec1aeda9782c59ef28da98fd51770604cf03a8493c140d158"
    sha256 arm64_ventura: "0b5161cda69c43b0255ee58f5d4b63f4415b008288d566b1cecbda59067f02d3"
    sha256 sonoma:        "a032d97b16278ceb396aab36e6073da845dc8217e3fdc3dfce4aa8b84a9a5eef"
    sha256 ventura:       "6b05a099bb0e1f268ade8905539ccc3010ebf19465af1aee6daf816c6e4b215b"
    sha256 x86_64_linux:  "45660f9ba46bdee8796564944735b77617544dc015ba32adefffab50037a350e"
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
