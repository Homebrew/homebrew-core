class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.0.tar.xz"
  sha256 "52460046d44776d936986f52649f9e48966b07e414a864d83531d43e568ab682"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9569f6f2da358dbc46a38c2b18162e53606250e346af5fc8e14314a5bf3be35"
    sha256 cellar: :any,                 arm64_ventura:  "4f98c00ec565b4e2c9d6c3f3fe1ebc2317833e3723f6a2e9ae4cf454b1c28af4"
    sha256 cellar: :any,                 arm64_monterey: "777a6cdbc7f5b33be2bb98b8eeead00b924e1400bbf67d4ec0e1edc0d3b948a3"
    sha256 cellar: :any,                 sonoma:         "c84f5e5d7a3e8635fc058e90126e9489d04abcde16fd440223ed3d92fcfea7bc"
    sha256 cellar: :any,                 ventura:        "1cd9f23919fd19bdbe41ac56b83bca967d02a752880d93acdb6089ab3eac6469"
    sha256 cellar: :any,                 monterey:       "9cca9affc6588bdba92edc3976cf7b826d5f2af564f171da0c1acb27f2b8fa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40ebc11d72ea9d2a100a5a75f0b5598700f1739c8f6087275aea64522b5396fc"
  end

  head do
    url "https://git.dynare.org/Dynare/dynare.git", branch: "master"

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

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  resource "homebrew-io" do
    url "https://octave.sourceforge.io/download.php?package=io-2.6.4.tar.gz", using: :nounzip
    sha256 "a74a400bbd19227f6c07c585892de879cd7ae52d820da1f69f1a3e3e89452f5a"
  end

  resource "homebrew-statistics" do
    url "https://octave.sourceforge.io/download.php?package=statistics-1.4.3.tar.gz", using: :nounzip
    sha256 "9801b8b4feb26c58407c136a9379aba1e6a10713829701bb3959d9473a67fa05"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    gcc = Formula["gcc"]

    # GCC is the only compiler supported by upstream
    # https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    ENV.public_send(:"gcc-#{gcc.any_installed_version.major}") if OS.mac?
    # Prevent superenv from adding `-stdlib=libc++` to compiler invocations.
    ENV.remove "HOMEBREW_CCCFG", "g"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-doc",
                          "--disable-matlab",
                          "--with-boost=#{Formula["boost"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-matio=#{Formula["libmatio"].prefix}",
                          "--with-slicot=#{buildpath}/slicot"

    # Octave hardcodes its paths which causes problems on GCC minor version bumps
    flibs = "-L#{gcc.opt_lib}/gcc/current -lgfortran -lquadmath -lm"
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

    statistics = resource("homebrew-statistics")
    io = resource("homebrew-io")
    testpath.install statistics, io

    cp lib/"dynare/examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~EOS
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install io-#{io.version}.tar.gz
      pkg install statistics-#{statistics.version}.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "-H", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end
