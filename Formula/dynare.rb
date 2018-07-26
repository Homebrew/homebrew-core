class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.5.6.tar.xz"
  sha256 "a4ff0ee5892a044d169ead2778e96fefcf617535fab28d25b977d8d008c7fe87"

  bottle do
    sha256 "efbdb7ef31ff4470593294f0bb04188c2adc9fbf3e83c068146610eab8118a07" => :high_sierra
    sha256 "8039dfd3518f0610fcce60859da27f5b60b46a2d7c203185aed25f7e42006d3a" => :sierra
    sha256 "9cf193a8cd86ecd6c8afd4440f64482fb8399dac81c107d59013d7a6d414b8cb" => :el_capitan
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
