class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-3.0.0.tar.gz"
  sha256 "5542b99042c09b2925f2e3700d769cda4fb411b476d446c833ea28c6bfa8792a"
  revision 1

  bottle do
    cellar :any
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
    # Disable testsuite, as of 3.0.0 is fails due to upstream issue: http://www.tddft.org/trac/libxc/ticket/22
    # system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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

    (testpath/"test.f90").write <<-EOS.undent
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
