class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://tddft.org/programs/octopus/download/libxc/4.3.4/libxc-4.3.4.tar.gz"
  sha256 "a8ee37ddc5079339854bd313272856c9d41a27802472ee9ae44b58ee9a298337"

  bottle do
    cellar :any
    sha256 "f8b5f2dff116944721e2a0f3d9b8de233dd7ed5672a7a5e049be46d479be364f" => :mojave
    sha256 "c3e5f9d0fc66335ce0d246d2ed308b0d1ece555db9a2c877bcbb493813cff9ff" => :high_sierra
    sha256 "0022f8f1f5d6f4fb7a842b1aef84660c2cf39b081d0003c5a21c365f8e6a35d8" => :sierra
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
