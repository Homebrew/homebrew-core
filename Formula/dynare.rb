class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.5.3.tar.xz"
  sha256 "01434f6d3ceaff1891dc771f6a5b39caee787b2ffa1875e5a4e8c673e32ff3d7"
  head "https://github.com/DynareTeam/dynare.git"

  if build.head?
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
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a", "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8", "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      lib.install "libslicot_pic.a", "libslicot64_pic.a"
    end

    if build.head?
      inreplace "m4/ax_mexopts.m4",
        /MACOSX_DEPLOYMENT_TARGET='.*'/,
        "MACOSX_DEPLOYMENT_TARGET='#{MacOS.version}'"

      system "autoreconf", "-fvi"
    end

    system "./configure", "--disable-matlab", "--disable-debug", "--disable-dependency-tracking",
           "--disable-silent-rules", "--prefix=#{prefix}", "--with-slicot=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    To get started with dynare, open Octave and type:

            addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    cp lib/"dynare/examples/bkk.mod", testpath
    octave = Formula["octave"].opt_bin/"octave"
    system octave, "--no-gui", "-H", "--path", "#{opt_lib}/dynare/matlab",
           "--eval", "dynare bkk.mod console"
  end
end
