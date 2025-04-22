class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.13.0/libgedit-tepl-6.13.0.tar.bz2"
  sha256 "5d738ca56ae31facba0d88b0a2e406b2507a3dc95f75bfb9f509ff4b2a9d20d3"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "836b139117cb325933282df854052d538ed5ba692b72c2aeaf87c2eeee468d8c"
    sha256 arm64_sonoma:  "c68c763cd2bbb1f8181553a806f475ca363738443a22bc51b633e8a7c5b8297e"
    sha256 arm64_ventura: "2159d88ea0072656253b7681c6a7e2bc5e59a62d8b6c55056b7cb14e4822293a"
    sha256 sonoma:        "2f853ef6c68bb210ac53ce6af23236e1b9d4de9c78c4ef4de8c96b1dc8c6e64b"
    sha256 ventura:       "5d4eecf87f2f780a100a28671d6da96f7af351c7233c9fd80993ed55e8243c37"
    sha256 arm64_linux:   "8849a4a7d619fe4fccca378574dbab76b15ae430ff78b98863af8b672d85f6b4"
    sha256 x86_64_linux:  "4600b539d283d30a8d6a96a74606cffc5ead3212da92e049bb9a391330cbb9ec"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@77"
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
