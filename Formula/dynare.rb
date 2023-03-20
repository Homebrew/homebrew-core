class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  license "GPL-3.0-or-later"
  revision 3

  # Remove when patch is no longer needed.
  stable do
    url "https://www.dynare.org/release/source/dynare-5.3.tar.xz"
    sha256 "bbbbd319f9a1cb7ffd4f7012be105a7c95842ca76d9d96e96305e1fbf8d8b585"

    on_arm do
      # Needed since we patch a `Makefile.am` below.
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "bison" => :build
      depends_on "flex" => :build

      # Fixes a build error on ARM.
      # Remove the `Hardware::CPU.arm?` in the `autoreconf` call below when this is removed.
      patch do
        url "https://git.dynare.org/Dynare/preprocessor/-/commit/e0c3cb72b7337a5eecd32a77183af9f1609a86ef.diff"
        sha256 "4fe156dce78fba9ec280bceff66f263c3a9dbcd230cc5bac96b5a59c14c7554f"
        directory "preprocessor"
      end
    end
  end

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2a5dd206e02a7f1d8e58337aee61e01c2851977fc1ec5c678bcdc37f8ccfa88c"
    sha256 cellar: :any, arm64_monterey: "f17a9c70db629dbaef1939b755bfc67f8efda0c64e6b157fa3cb8892081ebb20"
    sha256 cellar: :any, arm64_big_sur:  "7a842dc41dda9f15ee8022bf5e9eb33eae275ebd7e7019ebc131e9de58d658d4"
    sha256 cellar: :any, ventura:        "5e021895e4cea1895fe956a136b6be96a33b0cafa87d736b47437ef9878163de"
    sha256 cellar: :any, monterey:       "04ca3c4ce6e8aa004fa58c01fbb683b597a309d846f537e288826a26a194b85b"
    sha256 cellar: :any, big_sur:        "0e604eabaa5aceec883648f7f121b265f670324b8470890b92b9fce12887e386"
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

    # Remove `Hardware::CPU.arm?` when the patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" if build.head? || Hardware::CPU.arm?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
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
