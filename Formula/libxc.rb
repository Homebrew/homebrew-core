class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-3.0.0.tar.gz"
  sha256 "5542b99042c09b2925f2e3700d769cda4fb411b476d446c833ea28c6bfa8792a"

  bottle do
    cellar :any
    sha256 "9946ee821225893e5e4b8ef9b453d1df61472934bf415a8ddc47ccf1eb842ec3" => :sierra
    sha256 "b3b385ead0069356959d76135b9aa72d6cb492172c06a232720adadf243f9eeb" => :el_capitan
    sha256 "909e86fd8eccf2b7c356d3c4d17179cbaa3e9663846a27381d0268c1c9c00975" => :yosemite
    sha256 "993e4eb1dbe2c4f7cd1b73b46db0413bca8dc1128df6aab4f2d8cacef09d8e5f" => :mavericks
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int i, vmajor, vminor, func_id = 1;
        xc_version(&vmajor, &vminor);
        printf(\"%d.%d\", vmajor, vminor);
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
