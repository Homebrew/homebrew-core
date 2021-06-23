class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.1.5/libxc-5.1.5.tar.bz2"
  sha256 "60d9ead0f62e40991b6ff043242902090141c437343eb345a981ec8e3fd224d8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3b98ebf426e6f4b846d108d5f4b61b0d779d38bf9e356dfa14a365fac8f3c47d"
    sha256 cellar: :any, big_sur:       "66f9da21827ef2de8de328f6cd9024fc55f133fcf9f6d8aec4760255ff623c49"
    sha256 cellar: :any, catalina:      "123d5b60c730aebee03f3c15837e4202cd6e86e089df9b963b9b2d318da3b6aa"
    sha256 cellar: :any, mojave:        "3f7a4b898d3405c871a62e61b5bb874ccadb16d2e5d55783af870b638f927993"
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
