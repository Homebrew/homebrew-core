class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://www.tddft.org/programs/libxc/"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/3.0.1/libxc-3.0.1.tar.gz"
  sha256 "836692f2ab60ec3aca0cca105ed5d0baa7d182be07cc9d0daa7b80ee1362caf7"
  revision 2

  bottle do
    cellar :any
    sha256 "e3d95c1f73ad4dd2bbac39c0756e9da5cd77e6dd0761b04c8459147b2e367754" => :mojave
    sha256 "9ea81e66b245bde49b75db6707a2e6114eb83e393dbc25bcc07e81e2cf0d1c8d" => :high_sierra
    sha256 "8ac766961dcbb498caa01ca4a91a20dfadef0cba846ed82e02cc3da2f2bd41bc" => :sierra
    sha256 "7a0fc81d08b6e574d12a3b0b4a1bd033cb63a698e8b2ad508de1b84db94ed005" => :el_capitan
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
