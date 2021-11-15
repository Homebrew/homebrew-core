class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.88.tar.xz"
  sha256 "4f0d7f4aaa0bb2e725f349adf7b351a957d9fb26d555d9895a7af816b4167039"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a00ab8fc3289e795384974ddbfc26d43631f2e3bc5c5440031835842f6c3aa99"
    sha256 big_sur:       "f2e800564684938cfca18fc994eebcb3a2373f7362047513ca1a24f16c1937b0"
    sha256 catalina:      "33616239de78a0b3918cbb825913edd26ea49d2dbd0550a79ed7441052acb0a3"
    sha256 mojave:        "54e1710cab528ac2fd32300a1aa9577e1eb71ceae931792c356d2e5e582b2eaa"
    sha256 x86_64_linux:  "85379477d14b40b5972b729060678e5e91d2c13323c27c7f197434cc0650486d"
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
