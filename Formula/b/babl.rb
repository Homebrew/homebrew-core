class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.114.tar.xz"
  sha256 "bcbb7786c1e447703db3bc7fa34d62d0d2d117b22f04d8834c7b2d5ded456487"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "5ce954090d32baf2105b51b9181fc0033dd948598929f5391b17d3f64d89d6fb"
    sha256 arm64_sonoma:  "ebea9657244533795a3b5244acff93bdb0c68394e3f337b513fe10fa31e82ac2"
    sha256 arm64_ventura: "d69c75d99f6b01bb19b7e575bc05f2a105b5d16e6122c106c013163eb0afa63f"
    sha256 sonoma:        "711bcc1ca2003825471449a9d759f71c34e971909e6b5d46285c0bbc04d37198"
    sha256 ventura:       "80fac3c8153b352e4cae06c647461c1eccb8caa0295c5472354fd25719240178"
    sha256 arm64_linux:   "a6b592bfd886d0c851e52d4d58698b4b0f141a7e6c469fde635ba320444c6d48"
    sha256 x86_64_linux:  "3da3985cdc276fdfed64fce9fffdbbe174f5bd66ba2a9592619b80cc92b95a78"
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
