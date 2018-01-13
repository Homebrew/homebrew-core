class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/3.0.1/libxc-3.0.1.tar.gz"
  sha256 "836692f2ab60ec3aca0cca105ed5d0baa7d182be07cc9d0daa7b80ee1362caf7"
  revision 1

  bottle do
    cellar :any
    sha256 "486f2f22de676ceaf711a7203de362038d7f5aa1908bef486bb25fe2bb9a1948" => :high_sierra
    sha256 "79cfab56e69b107c8bc616ef1348d7ab1ea969a5283001abd79c689159f51e68" => :sierra
    sha256 "6618cfcb1cd1a7d69991e97fbc1cda0d67b0dc1f99232057cc0cac9895e031e6" => :el_capitan
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
