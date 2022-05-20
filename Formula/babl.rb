class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.90.tar.xz"
  sha256 "6e2ebb636f37581588e3d02499b3d2f69f9ac73e34a262f42911d7f5906a9243"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1ecbc84d8f7a0a2bc9a6f58b0d575632b71a3fb2f1e7f3a51a9b5e0d784b862b"
    sha256 arm64_big_sur:  "58bb5d38e7e04ecbb34f9e8bd9b5e192c31e19d8e4773467cc820635ede4e13e"
    sha256 monterey:       "3430b24cae096c8c2f00495508a8162af480235e2370d6e155904423a7c00e46"
    sha256 big_sur:        "ac951ddf734bd392fc3e4b9dfd5dffedbf39c6028e913f4f2cd5a80675385263"
    sha256 catalina:       "60aa4cf85fa631caa0501e494e990e77c523b3b32a2cacbe17766b98700b0c73"
    sha256 x86_64_linux:   "2cda652edb873aacf928ee293cea2f9d9a8b020bf7c2b53fbf502de339b2f0ca"
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
