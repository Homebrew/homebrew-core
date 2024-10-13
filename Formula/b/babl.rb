class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.108.tar.xz"
  sha256 "26defe9deaab7ac4d0e076cab49c2a0d6ebd0df0c31fd209925a5f07edee1475"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "ecf11548ba86ade713ca52e1c358f973bc1eee8006ce847d7b2fc68d3baf84ee"
    sha256                               arm64_sonoma:   "b40031e87d09f596d1a4eec30c1f8a752263b51f9b36b9055baa3c6350bc0e87"
    sha256                               arm64_ventura:  "3afa60e2de91e98faaf36ae02553ff9dc2d30e22efcf398bec37f699970191de"
    sha256                               arm64_monterey: "35197bb5cf889afe646b528923b5ab8f0e16c3faaa7cbc44632ac59470044183"
    sha256                               sonoma:         "545633dde92e33b2fdf3e4133563f2694ed59fd2c3fc5976514c02e50b9b50bb"
    sha256                               ventura:        "6e68c83d7cab437bb179e8605ac3500991b0c3c0a6ec961283c3eaa0d4043da7"
    sha256                               monterey:       "7d0093821f9ea7a511dd3e25ee81b98e546ad138e224037e41cd94a116f84104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd5cb9e839706921e6d8b9a068f25624debf9b86825851fd581de98e57b116b"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dwith-docs=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end
