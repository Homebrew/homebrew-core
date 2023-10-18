class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  license "GPL-3.0-or-later"
  revision 3

  # Remove when patch is no longer needed.
  stable do
    url "https://www.dynare.org/release/source/dynare-5.4.tar.xz"
    sha256 "c174a3ebcaf8c4566b9836abad8c04148011bec2ec610ded234f406bfbdd10f8"

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
    sha256 cellar: :any,                 arm64_sonoma:   "dca7a9f2c42dff817e2bd8b9506ca12286676f9901571b88103e1e79e657099d"
    sha256                               arm64_ventura:  "b0dd7c5ee63b6b5b43a1329794a1491ae1e146881f0786d79bf20866483bd0ef"
    sha256                               arm64_monterey: "cb8e792c83f4137b50ce60aeeaf2525eaed133771f26563d2fd5ef1206f707fd"
    sha256                               arm64_big_sur:  "7da08f1aadaf44592ac7ca9de4c19abe524e342d7f3cc9bf47f74287281c8084"
    sha256 cellar: :any,                 sonoma:         "0dc9b819826baed79e0ed4d6a2082bea09db15922ea2a55431f21030f63b157b"
    sha256                               ventura:        "f532e19598a494ee11f857210047c614389a0b707dd9b01e9b35af81b6f51f36"
    sha256                               monterey:       "307231733746225517044e5038d24c349e1a49c14fe796d48b9ac7edc9799ae5"
    sha256                               big_sur:        "0ba4e71943a7c99f86d03ca25d99c76c266d08041b02382f01f1471505c7d0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3da6684f9b314ccdbd400d8d17a2629e6ccfedae91839511fb4d42e97d98f23"
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
