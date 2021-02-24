class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-4.6.3.tar.xz"
  sha256 "1e346fc70a8ab47cad115ecb7116d98c920b366069a2491170661c51664352fd"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, big_sur:  "15c1b69d088625e07e469c0adb6da39e07256fd922c5a5e47c7ca6cde114a528"
    sha256 cellar: :any, catalina: "c7e5373a802c53a41978ab54be897f340a33380fc38898461b5a4c9d8cbc86b5"
    sha256 cellar: :any, mojave:   "e747a0ee8f372bbb12e9472eb7a1540f4dc5132480261f226bc709c973b0b405"
  end

  head do
    url "https://git.dynare.org/Dynare/dynare.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "io" do
    url "https://octave.sourceforge.io/download.php?package=io-2.6.3.tar.gz"
    sha256 "6bc63c6498d79cada01a6c4446f793536e0bb416ddec2a5201dd8d741d459e10"
  end

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  resource "statistics" do
    url "https://octave.sourceforge.io/download.php?package=statistics-1.4.2.tar.gz"
    sha256 "7976814f837508e70367548bfb0a6d30aa9e447d4e3a66914d069efb07876247"
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
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # GCC is the only compiler supported by upstream
    # https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{gcc_major_ver}"
    ENV.append "LDFLAGS", "-static-libgcc"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-doc",
                          "--disable-matlab",
                          "--with-boost=#{Formula["boost"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-matio=#{Formula["libmatio"].prefix}",
                          "--with-slicot=#{buildpath}/slicot"

    # Octave hardcodes its paths which causes problems on GCC minor version bumps
    flibs = "-L#{gcc.lib}/gcc/#{gcc_major_ver} -lgfortran -lquadmath -lm"
    system "make", "install", "FLIBS=#{flibs}"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    ENV.cxx11

    (testpath/"statistics").install resource("statistics")
    (testpath/"io").install resource("io")

    # Octave needs the resource tarballs, so we tar them back up
    system "tar", "-zcf", "statistics.tar.gz", "./statistics"
    system "tar", "-zcf", "io.tar.gz", "./io"

    cp lib/"dynare/examples/bkk.mod", testpath

    (testpath/"test.m").write <<~EOS
      pkg prefix #{testpath}/octave
      pkg install io.tar.gz
      pkg install statistics.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "-H", "--path", "#{lib}/dynare/matlab", "test.m"
  end
end
