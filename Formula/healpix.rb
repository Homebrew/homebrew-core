class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.82/Healpix_3.82_2022Jul28.tar.gz"
  version "3.82"
  sha256 "47629f057a2daf06fca3305db1c6950edb9e61bbe2d7ed4d98ff05809da2a127"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cee714500355c2f6d2974df7c1942d7d04dc1a99e7c6b729d2c0dfb3e346d680"
    sha256 cellar: :any,                 arm64_monterey: "2c20fec2724b39f5216682928570fa0b397bde0b5967fcdba09220381900211e"
    sha256 cellar: :any,                 arm64_big_sur:  "60149b975f08c9843300573050067fff1cd11c0cb37dfcd622099c2b71094791"
    sha256 cellar: :any,                 ventura:        "f668b103ad5eac9949f2bd52c1a694056cc7e716ace0d4b66829b856f86aa068"
    sha256 cellar: :any,                 monterey:       "b69b3a3ea09a205f5f753f2984e29de6052fae940b31d8a97dc3f6c502a78ed5"
    sha256 cellar: :any,                 big_sur:        "b4d35b6aedb577fa29673b4f5e6211c61675683fc9a328bcf186826d67a0dc1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21947253baf912a6367c4ee798a53c6b3b517c4e8774bd9b3edc2aeb2bff3de5"
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
