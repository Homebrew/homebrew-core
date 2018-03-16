class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/3.0.1/libxc-3.0.1.tar.gz"
  sha256 "836692f2ab60ec3aca0cca105ed5d0baa7d182be07cc9d0daa7b80ee1362caf7"
  revision 1

  bottle do
    cellar :any
    sha256 "10edb1b0047a9d08e4d86ebb49b3ff6f257649192be8f430893a29534c26cff7" => :high_sierra
    sha256 "fb24b4f5ce8c2c2a438b26cdd33264850911ccd91494e038fd320b3cab8e4688" => :sierra
    sha256 "7c5c77cef496e0d919fe0a99ee63c3594985be5f35d908bb4a1144f0dbad19bc" => :el_capitan
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
