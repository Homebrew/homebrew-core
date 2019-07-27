class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.5.7.tar.xz"
  sha256 "9224ec5279d79d55d91a01ed90022e484f66ce93d56ca6d52933163f538715d4"
  revision 3

  bottle do
    cellar :any
    sha256 "9b463bc35ef5fdf2fd302ef36a4afd183e0e26a0786be3c12be8994a09bc08d4" => :mojave
    sha256 "e2fe64b678d1b6005c7e157787d59e363b0e48c209a28bc1b1c191532db5d920" => :high_sierra
    sha256 "0872de7bb75b9e373db2c1619a3f67358ced227578996142a15f2db5fd233d41" => :sierra
  end

  head do
    url "https://github.com/DynareTeam/dynare.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    ENV.cxx11

    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-matlab",
                          "--with-slicot=#{buildpath}/slicot"
    system "make", "install"
  end

  def caveats; <<~EOS
    To get started with Dynare, open Octave and type
      addpath #{opt_lib}/dynare/matlab
  EOS
  end

  test do
    cp lib/"dynare/examples/bkk.mod", testpath
    system Formula["octave"].opt_bin/"octave", "--no-gui", "-H", "--path",
           "#{lib}/dynare/matlab", "--eval", "dynare bkk.mod console"
  end
end
