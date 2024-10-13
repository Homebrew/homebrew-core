class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.9.0/libgedit-amtk-5.9.0.tar.bz2"
  sha256 "ce800b862793a0c00239a14983a86657792e8777a9122bdb32d8ec81eea243ce"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "70ed2bfc3b08a403167d5a96a023bca4324c11e55a14fe04af86041f6f7f82ae"
    sha256 arm64_sonoma:   "c3bbe730b463ba9fcc65eaafcb6247f0320eb566716e3c0d0abbb9d353add130"
    sha256 arm64_ventura:  "f49182644bcf5261e8578adcf6cca696ea596fbeeee3a7334c215a6319ce959b"
    sha256 arm64_monterey: "5abf449fbaec5ccefabd03ff812d35d4235a1134da09a38e47d4729016b86a40"
    sha256 sonoma:         "8e8c682514431c8042a6bcab02dd2a9f5c829621d284ad03ace17772f0260bef"
    sha256 ventura:        "3a41ed675a07e493126f4deb8d5c85426698eaa9f9ba0544b87106bb7c4871a0"
    sha256 monterey:       "2e89649e6395b42bf253432cfbd1604465930bc95485d6ace2e699f15c0fd508"
    sha256 x86_64_linux:   "99ba215bd56bf06c96ade75b1ebae5c9965155f69f869c014a1878685dee0519"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

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
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libgedit-amtk-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
