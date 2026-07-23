class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/50/gsettings-desktop-schemas-50.1.tar.xz"
  sha256 "0a2aa25082672585d16fcdab61c7b0e33f035fb87476505c794f29565afa485b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61bf07681a37eef20b67ade4f31370875c84847669bf34c4a8cb103e63b239c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bf07681a37eef20b67ade4f31370875c84847669bf34c4a8cb103e63b239c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61bf07681a37eef20b67ade4f31370875c84847669bf34c4a8cb103e63b239c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "61bf07681a37eef20b67ade4f31370875c84847669bf34c4a8cb103e63b239c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "effe443ddfa766d16152d18b3fd847671928830e5654047786f1885e45e11cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effe443ddfa766d16152d18b3fd847671928830e5654047786f1885e45e11cb0"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    C
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
