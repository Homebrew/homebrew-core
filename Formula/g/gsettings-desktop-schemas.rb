class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/48/gsettings-desktop-schemas-48.0.tar.xz"
  sha256 "e68f155813bf18f865a8b2c8e9d473588b6ccadcafbb666ab788857c6c2d1bd3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28388575b4cdde9dbca9351e2589c4445e531fb7e4fa43905d96d3d89dd78d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28388575b4cdde9dbca9351e2589c4445e531fb7e4fa43905d96d3d89dd78d29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28388575b4cdde9dbca9351e2589c4445e531fb7e4fa43905d96d3d89dd78d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "28388575b4cdde9dbca9351e2589c4445e531fb7e4fa43905d96d3d89dd78d29"
    sha256 cellar: :any_skip_relocation, ventura:       "28388575b4cdde9dbca9351e2589c4445e531fb7e4fa43905d96d3d89dd78d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961057773b8eaa48b7a348fc0ac5ce5d14f8caa7785dc64bfb162b35e93e3bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961057773b8eaa48b7a348fc0ac5ce5d14f8caa7785dc64bfb162b35e93e3bf3"
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

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
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
