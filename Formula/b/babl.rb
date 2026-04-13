class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.126.tar.xz"
  sha256 "3f090f4b2a61fecf7c8dc60a5804bbc77cefd8d778af2ded059f0e367a52930e"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4eeeeb41469143b10d49950316a5ed2f23b71dc423c5490e0a668f024dd6234"
    sha256 cellar: :any, arm64_sequoia: "ddf1f588abb1318ff03920b45a0a041e888cfc01950591d11c7387f6c80a8abd"
    sha256 cellar: :any, arm64_sonoma:  "b54b7059335b3a9b04c1352263a15fc480d704b629fbf25a728de5de41154aa6"
    sha256 cellar: :any, sonoma:        "75435a454fb8e06256f1de4a9829d29dc2c0ee073ab52dc3c682afde988239b9"
    sha256               arm64_linux:   "c1fefb9e15036f64d0f2cba345337d3ed576b25243ee44c677645a2d933c81d5"
    sha256               x86_64_linux:  "a8df7b72aa8292978fc7c7f07b3237c3479c52a63be2cfe6170cf0d9a1dea4fa"
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
