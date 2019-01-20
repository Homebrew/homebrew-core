class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://www.tddft.org/programs/libxc/"
  url "http://www.tddft.org/programs/octopus/download/libxc/4.2.3/libxc-4.2.3.tar.gz"
  sha256 "02e49e9ba7d21d18df17e9e57eae861e6ce05e65e966e1e832475aa09e344256"

  bottle do
    cellar :any
    sha256 "d3cae48aff1879bd255e227fd5a305f5bfc537ad9e3b5709e09b434e4a43dffa" => :mojave
    sha256 "57b6d9d003ad48a50b571722e9fa59a3786f43fe90eab310ce75526c207c4b4f" => :high_sierra
    sha256 "ae70a828ecc3c097f6bc74660bbb60618be640b3c0f80db6c5fce0ea129c0c8c" => :sierra
  end

  depends_on "gcc" # for gfortran

  def install
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
    system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
