class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.120.tar.xz"
  sha256 "f476ad15201fb4ed0c90c174c524b1e4271ccd69a377242d6a69fcdf87ceacc2"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a6cdd30b36515405548dea32c43fda74a0edb5e5ebb93e1592eb6eeefa7ba00"
    sha256 cellar: :any, arm64_sequoia: "cc440456262aeefa6a3b2037db010fc01ae49b6c7192eb895accdf7898cc50db"
    sha256 cellar: :any, arm64_sonoma:  "11349f200cbf0534a009443320d529bd87ad94fb1e1990dad8a0f2ad5296aa9d"
    sha256 cellar: :any, sonoma:        "ee10ef4514cc70d59d140b61424541a9b223c5278cc1cfa39cd841f1a6ab5c3b"
    sha256               arm64_linux:   "2d98a649ac164ee9c14912fcaaa790d72bdd75c28cbd1fc0161bfff70f3e4148"
    sha256               x86_64_linux:  "6ab9a7da1ac0f57f42bd9a0b4cd1ce224e753247aa9a7980cae73f25217c0c25"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  uses_from_macos "libffi" => :build # to add to PKG_CONFIG_PATH for glib

  on_linux do
    depends_on "util-linux" => :build # to add to PKG_CONFIG_PATH for glib
  end

  def install
    system "meson", "setup", "build", "-Dwith-docs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    C
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end
