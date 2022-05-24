class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.81/Healpix_3.81_2022Jan25.tar.gz"
  version "3.81"
  sha256 "82d92bb21626371f9d280e59e82ad0f47d9ae62c70d86ccd1026e0310f193551"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dfeb28524f12bedc1dc9175497320abdcd8acff8f3c993d4bfb66ccc93cebd84"
    sha256 cellar: :any,                 arm64_big_sur:  "ba652ecb444db9af1ac44a9c63b45d97471f7f74a668dc1f4c5021da9501bbbf"
    sha256 cellar: :any,                 monterey:       "35518051713cd4a78e21496aa1118c35b5ff0c1806238bde84694b99d463fe58"
    sha256 cellar: :any,                 big_sur:        "59b6fc418e6e12988fb3e8a76ebaeaf009c03475da7a1f1d00835adea06e5087"
    sha256 cellar: :any,                 catalina:       "3572c5ccdc1ee37e02990a6f3b666b4c9a0653e746284d95119efb37ecaa3f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc0c6a9b81fdda8de5d1ef805042126fc6d2da0720e0a7df1caeb8fe56d6557"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    configure_args = %w[
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/common_libraries/libsharp" do
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{include}"
      ENV["SHARP_LIBS"] = "-L#{lib} -lsharp"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"
      int main(void) {
        long nside, npix, pp, ns1;
        nside = 1024;
        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    EOS

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
