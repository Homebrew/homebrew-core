class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.10.0/libgedit-amtk-5.10.0.tar.bz2"
  sha256 "7ee3d0cce3b21f3cc6a51ba644901b467da3b3c3e0b0adf74bd56c9e0e456140"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "9a97a6da9b9869ccfc4eeb45c527d579b6a5f646f719aac95a275f94d9d2ff3f"
    sha256 arm64_sequoia: "837a3adf99f31de0f7fa314998c19f34917b532c1ec0d0b7cf15078ebb0af7f1"
    sha256 arm64_sonoma:  "ef199b96da45bca35ce0c6a54ca34987ca57811ecc83cc8926d3afb29c37d44b"
    sha256 sonoma:        "bec5bc8941347e1bc91a024876beea8ef801a335c0ef4b8aa1aa42f59a0d7942"
    sha256 arm64_linux:   "ba79ceb4612e7a04b6e4a246e8890eb8d0240d7d3c55601b41fefa26b704002b"
    sha256 x86_64_linux:  "f682994518431437323aeec6e87a29dba13750c68bb291e4f97ba05b574aeabf"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-amtk-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
