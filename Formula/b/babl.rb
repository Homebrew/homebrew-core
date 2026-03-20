class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.124.tar.xz"
  sha256 "1b0d544ab6f409f2b1b5f677226272d1e8c6d373f2f453ee870bfc7e5dd4f1b1"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "27aea7a6f63a2e1ba8d6a595b59857562c68294c2eedd5c433b9a514c8ee6a1d"
    sha256 cellar: :any, arm64_sequoia: "a580f00306ff64feef4979435e06b2e2f0b11e962f3a57dbfefbb511788a2b6b"
    sha256 cellar: :any, arm64_sonoma:  "a60ac02f7b06ccfeeb08fbc3c7f67f82590d20bd6ad4540db3ab480aba314c91"
    sha256 cellar: :any, sonoma:        "6f307d9c04db4f2dbeb71c17c35945f9c6c03523543637216a115437ebdad149"
    sha256               arm64_linux:   "e47f059154814c4e8a72ebffa9ce751792e8f0851a2cb9ebd116f47e88d376c9"
    sha256               x86_64_linux:  "9700ef030c0593a7768b0e3fd7040ed815ea02c369b2d2586bbbfb2ccee3c705"
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
