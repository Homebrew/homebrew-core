class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.0.0/libxc-6.0.0.tar.bz2"
  sha256 "f182fac31ba7682e3483cb89837be090a266a3349593fafb147ab2e203f36a57"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "76984fead2d7c7162093695d21d7c5b5966087b60a84e9995480851cc742d002"
    sha256 cellar: :any,                 arm64_big_sur:  "6667ca67895897ca00340ecc4164449483f46e226affae45a70ca62f1f7d8a7c"
    sha256 cellar: :any,                 monterey:       "baabce501ca109c134573955355b005279a151e01d3dc93ad60f0d0ac8ffe104"
    sha256 cellar: :any,                 big_sur:        "e2a9c845aef36fe679b3694cd8aa3b446b37ceec17bfaee76d5412881e61dd39"
    sha256 cellar: :any,                 catalina:       "d0ce63f9d4f79cd42bb34b5cf53b535d96adbf527d2865c3b8b0ad52278e3249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08ca5a0e6a6976022c59789c27052b16b5d44cc4eab0fe3f0fa295fcee57e20"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=gfortran -E -x c",
                          "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
