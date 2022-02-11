class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.2.2/libxc-5.2.2.tar.bz2"
  sha256 "484115929674d7b85d9361f4f8a821e3d1c6024e31b8fa41df916c09799891a9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5023e89f8acff465eba113360911e6b666c4487f9547271da78be13ccfb9c9d"
    sha256 cellar: :any,                 arm64_big_sur:  "4e064d20223090cc16b6a9056bca6cbd98683408c42987b7a0050016bac46b41"
    sha256 cellar: :any,                 monterey:       "1751dc87e5235aa9854442dea65fb1355f2f847157fdae990e315fb96b3d34b0"
    sha256 cellar: :any,                 big_sur:        "4fb029189385ada09e3c4a167257bb1e39ff02fc3fa00c4d0e03c6b45dd5cafd"
    sha256 cellar: :any,                 catalina:       "091fc935e2496b8132bfefc25372b496af7a1c9a93952ff6ff36dbc130445808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41cf6427cdce0071ce177114d46b588fd24a75512b005b2da0b14d2c1cc1c503"
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
