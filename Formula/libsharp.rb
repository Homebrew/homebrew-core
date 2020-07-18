class Libsharp < Formula
  desc "Library for optimized Spherical Harmonics operations used by Healpix"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.60/libsharp-1.0.0.tar.gz"
  sha256 "e98293315ee0f8a4c69c627bda36297b45e35e7afc33f510756f212d36c02f92"
  license "GPL-2.0-or-later"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include "libsharp/sharp.h"
      #include "libsharp/sharp_almhelpers.h"

      int main(){
        sharp_alm_info *alm_info;
        sharp_make_triangular_alm_info (0, 0, 0, &alm_info);
        return sharp_alm_index(alm_info,0,0);  
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsharp"
    system "./test"
  end
end
