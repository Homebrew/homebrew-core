class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.14.0/libgedit-tepl-6.14.0.tar.bz2"
  sha256 "2b695f41475573aa59f1cd004b5cc3d2021d0444decf26eb8d38864348fb3577"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "20148171f340884e2ea8580f1a4870d15c5a8c498b1029f6515aeb4b735f03eb"
    sha256 arm64_sequoia: "ea7f006494423aea8a7816f2d3f331eb8116cadc3688bf7f4f052f6462a80b5f"
    sha256 arm64_sonoma:  "25274a0255b4b8e6d9f36e72ac80eabfde8f4270659c7d4cf73d33e5e828fce2"
    sha256 sonoma:        "f49ac4935063ff4b08e5cea8959829d7a2f37074a9c69bb6624cd3c9f4a051eb"
    sha256 arm64_linux:   "ee8f02ca17eec111b5dac39e0ee9b4cfe56809638515f656dcee879014c4cccc"
    sha256 x86_64_linux:  "1a8e119f8d5b3f48264f88979bae8b14041665aed64dc3aff5b0a46db32918f8"
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
