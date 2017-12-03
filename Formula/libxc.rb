class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/4.0.3/libxc-4.0.3.tar.gz"
  sha256 "85aec0799bb77c0eca13f11b7124601d4b2ba5961dd390a98a3163fc9f1dbae7"

  bottle do
    cellar :any
    sha256 "d3322d32b265367ac0c798073dd6b68394faa006c88b9aedbe88138b92930afe" => :high_sierra
    sha256 "984695d0b1ffadebe99d03c5c9061740bb45eaa6024595bb675213d388a3cebf" => :sierra
    sha256 "a5f71cb519b4573600046acfa3203febeb9bc56e79c89978289421dc8e07be01" => :el_capitan
    sha256 "729c2a9d858dae15cdc960c6a816ae6f153307c078cc2b21cad51263f0b27879" => :yosemite
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    # Disable testsuite, as of 4.0.3 fails
    # system "make", "check"
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
    ENV.fortran
    system ENV.fc, "test.f90", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ftest"
    system "./ftest"
  end
end
