class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.64.tar.bz2"
  sha256 "bb774d30b403511b95aa42f833a3562580c3b7cf3187f0923748d17775d158bf"

  bottle do
    sha256 "301e2ceee63f3228e021efb8259ad0024ca3f1eff6e83949f52fdec19a4f1407" => :mojave
    sha256 "0663e02daad3ee5a7c95612debca4312bf8f7a25f1b20037a615a394e74236f9" => :high_sierra
    sha256 "3a909e1bf30b9c9df81740f9e967f9eda182bb7393d85cf00efb9d31c413d402" => :sierra
  end

  head do
    # Use Github instead of GNOME's git. The latter is unreliable.
    url "https://github.com/GNOME/babl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
    system ENV.cc, "-I#{include}/babl-0.1", "-L#{lib}", "-lbabl-0.1", testpath/"test.c", "-o", "test"
    system testpath/"test"
  end
end
