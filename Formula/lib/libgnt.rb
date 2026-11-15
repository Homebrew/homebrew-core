class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.15.0/libgnt-2.15.0.tar.xz"
  sha256 "6dce3d4f2fb33c242d8223ddda5f1042f3dfb0ad7c395d4e33a73f92423a58a3"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/libgnt"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5445aa5f1e7551a1cbd4260738c1b4fe0a878b025f42ac0574f0743ca167e5e"
    sha256 cellar: :any, arm64_tahoe:       "b527b2f03c67197b52f9b78fd2eeece7a6a873fee179373913308c1d00873614"
    sha256 cellar: :any, arm64_sequoia:     "b182ba465d144c5b1bf0a2033d034ea6ef5343b62c14005db32722a40884dc8b"
    sha256 cellar: :any, arm64_linux:       "6ef933392dfc3e8a90097606ce182fd78c9a59e67912b50b6a13fb47558540e8"
    sha256 cellar: :any, x86_64_linux:      "8877647da1d1687289a473e3628eab6e34ca30bfceaec686fe8d3aec27d64d2a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "meson", "setup", "build", "-Ddoc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    C

    flags = [
      "-I#{formula_opt_include("glib")}/glib-2.0",
      "-I#{formula_opt_lib("glib")}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{formula_opt_lib("glib")}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
