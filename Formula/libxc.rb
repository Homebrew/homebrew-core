class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.1.6/libxc-5.1.6.tar.bz2"
  sha256 "0ee0975a1dd54389e62d6dc90ae0b8c7bb0cdcafde8e3ce939673be5a0c3aae3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bab54fd6f307ac24bc5bd3ab6141daf2149abc990f3d1c2774164a4953d5fe03"
    sha256 cellar: :any,                 big_sur:       "042fd1f69c5eb656fafb3132e3e74e6243db2d54bb085e825772c78e4ebb1c8e"
    sha256 cellar: :any,                 catalina:      "e35ea54099046a72da1e9ac35e838b12055aef0c5c81be282e579758c640df00"
    sha256 cellar: :any,                 mojave:        "eb030e211e6523a252007c84e330bd0e6248ddc14676d61f5daf1b328ca219b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59641b78ef6a37cab93991fba107c4a2dd62a610c54adda0766bed0ba7b38ee6"
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
