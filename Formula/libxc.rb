class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://tddft.org/programs/octopus/download/libxc/4.3.4/libxc-4.3.4.tar.gz"
  sha256 "a8ee37ddc5079339854bd313272856c9d41a27802472ee9ae44b58ee9a298337"

  bottle do
    cellar :any
    sha256 "368e272c4184fb951348a223f1c740020a76999b552d23c84c1c45aa88366902" => :mojave
    sha256 "7ee404c4bbd65309cdd25a992a9e92dfea57cf7af6372381852f76b82e3fdc30" => :high_sierra
    sha256 "fb1f4e04633838f4bd9301d3a33175842680d1c1301971edce5b0179e459043f" => :sierra
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
