class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.60.tar.bz2"
  sha256 "a3d1eeccb6057ccbc189dc926ebaca96cd4896f3391f857b86334d2245f0604f"

  bottle do
    sha256 "d4919702e5918f9f47b76cf9dbff294efbd26c909eea3084e0ca6991f212738e" => :mojave
    sha256 "be17bcd75c569fe2b90f81c2b7dd8e051c07ead256eb8665c739b4abd1b86b40" => :high_sierra
    sha256 "225d7ef87fe7dcfe9ba9134531b9d5420afc9354bf8fe7bde11bb7bbf4ecf2f0" => :sierra
    sha256 "6aadd8934b96132fd208f0526a0caacb4df6e7c13f3507ea8078a070d5914ea6" => :el_capitan
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
