class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.96.tar.xz"
  sha256 "33673fe459a983f411245a49f81fd7f1966af1ea8eca9b095a940c542b8545f6"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "64c8b2c66d553f2b0de3e8daf1a42ca9801b3ee25a07a1c19a9fc27f6c28b913"
    sha256                               arm64_big_sur:  "4a7ffd11316c9c16c594a10bda037db29c5dedb9b5bb6110a05fe4f95e4c89fe"
    sha256                               monterey:       "75a5d52d2d35b7cbf9d64d1265c423dcc067cd64943b1f6f7228c6bf8e005770"
    sha256                               big_sur:        "968dcf8b7dc248ddf031bf18e6df7f4c0928415ce9ab80bfa64dac476b1005cd"
    sha256                               catalina:       "271e7ae1cac571441212d26cf2e0f7498e9dfb6990a5f22da569ba7d74835bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92381d3869a38879f1a95351a9ae5e880d9813ac4a237f532879decd23ad70b"
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
  end
end
