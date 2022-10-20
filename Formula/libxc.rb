class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.0.0/libxc-6.0.0.tar.bz2"
  sha256 "f182fac31ba7682e3483cb89837be090a266a3349593fafb147ab2e203f36a57"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c79670f57d0b3a0d10876f02f50cf0061c530e97ddf6e412d0f17a0a6644f6ad"
    sha256 cellar: :any,                 arm64_big_sur:  "e07b6d39d96b23c2f67fee2f93737414653141e62be76b20261173628f54edcb"
    sha256 cellar: :any,                 monterey:       "981570c3575c0002c486b25ccbf162e6c212c5bd9dee5c9d5d685ed010942a82"
    sha256 cellar: :any,                 big_sur:        "8ca05881128815959c1ba12d69e243fa9ec5396560b89d41dc3c99054b755913"
    sha256 cellar: :any,                 catalina:       "3778d34932ecf2ea3df3dbe49f8c8732384b7d1fd7d8470c65cce7515cd30617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba382f85ebaaf0c8c2e4b0b066d5b418968b5f50a6ac1b1b3e44c27704fb690f"
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
