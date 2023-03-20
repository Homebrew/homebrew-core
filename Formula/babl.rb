class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.102.tar.xz"
  sha256 "a88bb28506575f95158c8c89df6e23686e50c8b9fea412bf49fe8b80002d84f0"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "58933e6ff3b4668a99ca68b66675aff978a82e73fd6a73c8ec8ae42a153a4f5b"
    sha256                               arm64_monterey: "4035c252ad05ff6a8c9dbc2aee4cd2e04bc1b530193f923b2a631d7168308c76"
    sha256                               arm64_big_sur:  "09a93b17b65015ce5e6d99511456107bde7613669ec7733a075f1e6228b173ff"
    sha256                               ventura:        "4d63f7966c3b9303917ef263c8c14d7de11e1e265649b272834880f10609ac32"
    sha256                               monterey:       "b658b5b00cb490a4447d76961ffdb5e79d85a0f4846bd1dede71e1466b75729c"
    sha256                               big_sur:        "c69922cb98949769c7bcc45caa60b3a4005273eb9babdebf12120be1ab779723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b441f493212b7949ee45db5ba186860ab885255b8c284a67132f7d60967edd41"
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
