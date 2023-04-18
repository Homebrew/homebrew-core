class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.1.0/libxc-6.1.0.tar.bz2"
  sha256 "04dcfbdb89ab0d9ae05d8534c46edf4f9ba60dd6b7633ce72f6cb3c9773bb344"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0948e1952d8f9c82cb40b92e85b307abb90695ead9e1feacdd649aacd1950f2f"
    sha256 cellar: :any,                 arm64_monterey: "197c0a86d1003f63d6ef7232686e5ef20933a21106ff579402276e517e641b54"
    sha256 cellar: :any,                 arm64_big_sur:  "65146c97950799978716834f772b374e2b794f332b7e6f0487aefe9b29b90149"
    sha256 cellar: :any,                 ventura:        "03d69df473f57031fb1e9c1768d72a334842c0c7b8cc1d7eedc51b46dfb66e47"
    sha256 cellar: :any,                 monterey:       "1169534fc5a3ecdaa1b7aa6e9c54ec8a89a45df1ddab0b254104aac933ada32b"
    sha256 cellar: :any,                 big_sur:        "dd56b362469199f447b6b2fe6dfe9caa85e1c6047bbbac30497777d7c49a94e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50be3c335300036209e21277788fa9fba694265c3e66dd56f09327924f087825"
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
        printf("%d.%d.%d", major, minor, micro);
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
