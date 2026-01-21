class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/49/gsettings-desktop-schemas-49.1.tar.xz"
  sha256 "777a7f83d5e5a8076b9bf809cb24101b1b1ba9c230235e3c3de8e13968ed0e63"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e48c2263a6b10990898745fbed2b7ba91ec78053a53d4f3c8a6598b567adbf39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48c2263a6b10990898745fbed2b7ba91ec78053a53d4f3c8a6598b567adbf39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48c2263a6b10990898745fbed2b7ba91ec78053a53d4f3c8a6598b567adbf39"
    sha256 cellar: :any_skip_relocation, sonoma:        "e48c2263a6b10990898745fbed2b7ba91ec78053a53d4f3c8a6598b567adbf39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58faeed213ad74ce4c486cd1744443efa5d764d34e64aaa8dafc6a043f90186b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58faeed213ad74ce4c486cd1744443efa5d764d34e64aaa8dafc6a043f90186b"
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
