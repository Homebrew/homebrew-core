class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.5.4.tar.xz"
  sha256 "5ee1c30e9a8e0c0ec4f60e83c02beb98271f9e324b9b667d4a5f5b2ee634a7e6"

  bottle do
    sha256 "99b20935eb0a0e22b482fe50a9ab72d8521db2effbc2de604dcf22d19e75be95" => :high_sierra
    sha256 "89c7f0cca0533d6b5cc16bdd64e3bf8343bcd4a0f64116e34e539a767c843e54" => :sierra
    sha256 "c7ce5fcab53cbad43574d5920725216f98b81d5664e11f7e7db95bb4b092caa5" => :el_capitan
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
