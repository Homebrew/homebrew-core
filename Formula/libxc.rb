class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.0.0/libxc-5.0.0.tar.bz2"
  sha256 "b4206940db57ba4ddb9cb635fd852914c8dd045cb07bab32427013e3ab294f4f"

  bottle do
    cellar :any
    sha256 "072df8c5f3e00bf045f4e062993ecb08e324872daf3503b8f2bacef866a3de14" => :catalina
    sha256 "7727321091982306464ad87e055074b2675d83ee3c8416cf6b0681a4db31bc85" => :mojave
    sha256 "c8f820ca8dce64220c8c1e60002a13c4ed21d5decfd6b1189b6d286ca5c47ab4" => :high_sierra
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
    system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f90_lib_m
        TYPE(xc_f90_func_t) :: xc_func
        TYPE(xc_f90_func_info_t) :: xc_info
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
