class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.1.4/libxc-5.1.4.tar.bz2"
  sha256 "17ea2328552bccc01463b76f41c297bde8bfc4868951a08c010aba326222cebe"
  license "MPL-2.0"

  bottle do
    sha256               arm64_big_sur: "08e052bb3fdc234263a6bafffd84ac393ad7bec9c9053af7b758177313a5cf63"
    sha256 cellar: :any, big_sur:       "2173f36d9439252a028507c8a10f9c918aebdd7804740e4946706fbf13a6ca54"
    sha256 cellar: :any, catalina:      "5b6a06de05d4f4539c46a66e300980848f00f36e221e3988bb08b453aa2ee7db"
    sha256 cellar: :any, mojave:        "3839693eabb3936f15ad769250ee539087b627c3f5ee1d65b1a37504c991f421"
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
