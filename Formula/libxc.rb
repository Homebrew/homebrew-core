class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.1.7/libxc-5.1.7.tar.bz2"
  sha256 "a1f8ffa50a6b06f20a1dd49bc54445799193f4e7d297052caad39cff47cea8b4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "27be1a841edbc6147a1ce89eee4564da177e7337b09d7861c8a99badb7341b35"
    sha256 cellar: :any,                 monterey:      "2382891c001007f27add5773c6753478fe69e30ec479470f62fe8a5a9478a466"
    sha256 cellar: :any,                 big_sur:       "e17c6a274cda913afcc1e549c9a2d9c7c864cb1f4f6b44766023a52ca68f5b52"
    sha256 cellar: :any,                 catalina:      "ace72161096c3243b983c3d8b3d564c6f8149616fd6dbc49da8c65e3f02a0395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee43e7f27ab0b94475bf1b7e1e4c1245c61b2e6e1e4f8d3d15386c3c0f1dc01"
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
