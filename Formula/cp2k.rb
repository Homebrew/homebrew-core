class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://downloads.sourceforge.net/project/cp2k/cp2k-5.1.tar.bz2"
  sha256 "e23613b593354fa82e0b8410e17d94c607a0b8c6d9b5d843528403ab09904412"

  bottle do
    sha256 "8031b0558f47e19243361ff95f3a151a0d4d778e6f1877b9daeedbab4a0b9be4" => :high_sierra
    sha256 "af6225fd780c3ba76a7d926f162757f178f885a2d7e822d9cf57efd14b1c37cb" => :sierra
    sha256 "accb2f2ddc22665e149f9b8e65f2e0eeedeaba55eeddf95f3ca9fc851baacef5" => :el_capitan
  end

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on "fftw"
  depends_on "gcc"
  depends_on "libxc"
  depends_on "scalapack"

  needs :openmp

  resource "libint" do
    url "https://downloads.sourceforge.net/project/libint/v1-releases/libint-1.1.5.tar.gz"
    sha256 "31d7dd553c7b1a773863fcddc15ba9358bdcc58f5962c9fcee1cd24f309c4198"
  end

  def install
    resource("libint").stage do
      system "./configure", "--prefix=#{libexec}"
      system "make"
      system "make", "install"
    end

    fcflags = %W[
      -I#{Formula["libxc"].opt_include}
      -I#{Formula["fftw"].opt_include}
      -I#{libexec}/include
    ]

    libs = %W[
      -L#{Formula["libxc"].opt_lib}
      -lxcf90
      -lxc
      -L#{libexec}/lib
      -lderiv
      -lint
      -L#{Formula["fftw"].opt_lib}
      -lfftw3
    ]

    # CP2K configuration is done through editing of arch files
    inreplace Dir["arch/Darwin-IntelMacintosh-gfortran.*"].each do |s|
      s.gsub! /DFLAGS *=/, "DFLAGS = -D__LIBXC -D__FFTW3 -D__LIBINT"
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
