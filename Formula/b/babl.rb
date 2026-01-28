class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.122.tar.xz"
  sha256 "6851f705cda38f2df08a4ba8618279ce30d0a46f957fe6aa325b7b7de297bed2"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "068356ce3cb3c0b2de5caf5d90021792f130363042f3cf07f8886026ab70e76c"
    sha256 cellar: :any, arm64_sequoia: "86f3d5841772c83b64806942ec1df1b9b25bcbb969e21df0d505b7fd46f2f2fb"
    sha256 cellar: :any, arm64_sonoma:  "92c59044ac29409f96fd981ace89c489771bec3e0f5e8dbef3774eaca80bcf04"
    sha256 cellar: :any, sonoma:        "2c57b89583404bbd1328cce45bfdb2adebe41f32411f9f60b61361482d726360"
    sha256               arm64_linux:   "5e8e300c057a5bb2cc5e369758e3887aa94349a9aec3a8135f164f08aac7260e"
    sha256               x86_64_linux:  "b43bf7024e313d6f6ddcf94ada47a8442f81a3b67508d0fffb48e5ea8dffef90"
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
