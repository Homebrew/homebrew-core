class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.2.3/libxc-5.2.3.tar.bz2"
  sha256 "6cd45669d7f92bdcdb6879bea232dac94ad57d025cf2edfd019182ccf6494a75"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab53f54b78b5af31ed1ec2e0f366153e72a6d52b556afda8b4f4e83590ac986b"
    sha256 cellar: :any,                 arm64_big_sur:  "e6e36a5e5b432010f6fe490cda08777e9f73cc724ba695e20fe0eebd7f0e4c11"
    sha256 cellar: :any,                 monterey:       "89b024d837b6bc171be052458332dc08ca642998b3ad853ca27992178855b352"
    sha256 cellar: :any,                 big_sur:        "4d4e5db654f348da273358f4a7268793945b12a100f6ac7aa69e4b6b2f129d6b"
    sha256 cellar: :any,                 catalina:       "c74354016c997bc59947f5b6882fd8b0df5e65237bcd7879a2a44b6aaf4c0e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8b90733fdaed749ef20fce3360c1eff0c0e247c8716eb4754aa7ca8869ca86"
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
