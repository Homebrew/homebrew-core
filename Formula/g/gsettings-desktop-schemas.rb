class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/50/gsettings-desktop-schemas-50.0.tar.xz"
  sha256 "358f07cb253727650e132805df3c69f7bf90448040bce171b6f6f2cb1b9c37ef"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e00b14ce294a371ad702090c9cd388a6ea36f4cb1bdbe1fec4a711c5b0327d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00b14ce294a371ad702090c9cd388a6ea36f4cb1bdbe1fec4a711c5b0327d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00b14ce294a371ad702090c9cd388a6ea36f4cb1bdbe1fec4a711c5b0327d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "e00b14ce294a371ad702090c9cd388a6ea36f4cb1bdbe1fec4a711c5b0327d91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e07862c8017327db05f762a319e7d172496bce6ea1d9d0eda4da6afeb9f94f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e07862c8017327db05f762a319e7d172496bce6ea1d9d0eda4da6afeb9f94f7"
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
