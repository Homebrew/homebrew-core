class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.2.1/libxc-5.2.1.tar.bz2"
  sha256 "15dd8c899be82c3cac93474b9b5cd6e5d8ad7b4ce22c9e43c3b9d10ed6ae42bf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c56f9e632b21377378a480c14cbe33782fa23ea88336611e73fe6c34cbeb299c"
    sha256 cellar: :any,                 arm64_big_sur:  "ec447a37c9c27575a6ab3034ae71858e7d85f150fff7c8da838f4145cc11af5d"
    sha256 cellar: :any,                 monterey:       "d7917fb4247f6cdea7e037b7459ce3a45227e0cf4430dea9e487d1bded8aa2d8"
    sha256 cellar: :any,                 big_sur:        "9e477e9f665a362dd0768e944c0cd17d8f7a629748a76ea5dc92b2bc66d0d650"
    sha256 cellar: :any,                 catalina:       "6c2439cbe6b2256416886e6dfb6e10f6433c33ebc8f8593d271fd983afa3ab2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1263b33deda44e0784dda29e36dc9bfc053e29bada700ac36075f40c717ad76"
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
