class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v6.1.0/cp2k-6.1.tar.bz2"
  sha256 "af803558e0a6b9e9d9ce8a3ab955ba32bacd179922455424e061c82c9fefa34b"

  bottle do
    sha256 "e42f801db8413f396167a2c4c71bb1d4e0ab5352bf176ea835a6d894b5740fc9" => :mojave
    sha256 "886f8dd477a34f861724a52b62bf519dd945dd1c7e5f4f3bbed0785493ebf6ec" => :high_sierra
    sha256 "1feda0f7944c4a7e9e5832657665495ab0330230acc0ddcf4197600408eec1f5" => :sierra
  end

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "scalapack"

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https://downloads.sourceforge.net/project/libint/v1-releases/libint-1.1.5.tar.gz"
    sha256 "31d7dd553c7b1a773863fcddc15ba9358bdcc58f5962c9fcee1cd24f309c4198"
  end

  def install
    resource("libint").stage do
      system "./configure", "--prefix=#{libexec}"
      system "make"
      ENV.deparallelize { system "make", "install" }
    end

    fcflags = %W[
      -I#{Formula["fftw"].opt_include}
      -I#{libexec}/include
    ]

    libs = %W[
      -L#{Formula["fftw"].opt_lib}
      -lfftw3
    ]

    ENV["LIBXC_INCLUDE_DIR"] = Formula["libxc"].opt_include
    ENV["LIBXC_LIB_DIR"] = Formula["libxc"].opt_lib
    ENV["LIBINT_LIB_DIR"] = libexec/"lib"

    # CP2K configuration is done through editing of arch files
    inreplace Dir["arch/Darwin-IntelMacintosh-gfortran.*"].each do |s|
      s.gsub! /DFLAGS *=/, "DFLAGS = -D__FFTW3"
      s.gsub! /FCFLAGS *=/, "FCFLAGS = #{fcflags.join(" ")}"
      s.gsub! /LIBS *=/, "LIBS = #{libs.join(" ")}"
    end

    # MPI versions link to scalapack
    inreplace Dir["arch/Darwin-IntelMacintosh-gfortran.p*"],
              /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_prefix}/lib"

    # OpenMP versions link to specific fftw3 library
    inreplace Dir["arch/Darwin-IntelMacintosh-gfortran.*smp"],
              "-lfftw3", "-lfftw3 -lfftw3_threads"

    # Now we build
    cd "makefiles" do
      %w[sopt ssmp popt psmp].each do |exe|
        system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=#{exe}"
        bin.install "../exe/Darwin-IntelMacintosh-gfortran/cp2k.#{exe}"
        bin.install "../exe/Darwin-IntelMacintosh-gfortran/cp2k_shell.#{exe}"
      end
    end

    (pkgshare/"tests").install "tests/Fist/water512.inp"
  end

  test do
    system "#{bin}/cp2k.sopt", "#{pkgshare}/tests/water512.inp"
    system "#{bin}/cp2k.ssmp", "#{pkgshare}/tests/water512.inp"
    system "mpirun", "#{bin}/cp2k.popt", "#{pkgshare}/tests/water512.inp"
    system "mpirun", "#{bin}/cp2k.psmp", "#{pkgshare}/tests/water512.inp"
  end
end
