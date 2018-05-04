class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.5.4.tar.xz"
  sha256 "5ee1c30e9a8e0c0ec4f60e83c02beb98271f9e324b9b667d4a5f5b2ee634a7e6"
  revision 5

  bottle do
    sha256 "3d3a8047734e00f273882ccc8df351f0a6b6d5dad8fa059d97dd7e194458417e" => :high_sierra
    sha256 "12ff985d10a0723501074cd4b14b98e4cc476586bbab7fd3b6530da4310212d4" => :sierra
    sha256 "455fde45d8ff9f988a007c56e2b07749be6fa21c5b069121c9a2541db99f7989" => :el_capitan
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
  depends_on "suite-sparse"
  depends_on "veclibfort"

  needs :cxx11

  resource "slicot" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    # config.h was renamed octave-config.h in Octave 4.4.0
    inreplace "mex/sources/ms-sbvar/modify_for_mex.h", "octave/config.h",
                                                       "octave/octave-config.h"

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
