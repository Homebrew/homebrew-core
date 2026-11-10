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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "470a5b552681ca246a1c280577634612d5b7529e356ac0090d05ca881a128465"
    sha256 cellar: :any, arm64_tahoe:       "f194c5894d88e0a404bacc329bebc7e07a30af1f61ec7e2b6f8204e88b466aef"
    sha256 cellar: :any, arm64_sequoia:     "6e2509cb3857c6e6f3bf0ee75c4a1fbfdfafbd4bb31259480b201b24e6d1a32f"
    sha256 cellar: :any, arm64_sonoma:      "9eab534c24c28acf0f8b40b9133372a22ad41871c0148d4695c88614f239c49f"
    sha256 cellar: :any, sonoma:            "ac8130649a42b951a8135577fe6e6187000a1529662b26f661f55c8389bde2bb"
    sha256               arm64_linux:       "be782198220e55ec2a36f237fb74adf716fd9eb7ad25c70c875412808b7269f3"
    sha256               x86_64_linux:      "0ea6543956c903e13d322177daf7e700bec8c264e7c8e25b98179fc7624a4be6"
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
