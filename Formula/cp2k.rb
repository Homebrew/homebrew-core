class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2022.2/cp2k-2022.2.tar.bz2"
  sha256 "1a473dea512fe264bb45419f83de432d441f90404f829d89cbc3a03f723b8354"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "1e61b286d38435d6e0b171bc4720ed1b5259abafc46478c70260303aa7a04972"
    sha256 cellar: :any, arm64_big_sur:  "77b3b54d1c2f15a60c6eba44c172b7ef412be2842fa29e5932a9832220b31791"
    sha256 cellar: :any, monterey:       "cb16c0faf926a4ff2a4945edc5e93d25e11188851a77483097ce4f3758f2ef3a"
    sha256 cellar: :any, big_sur:        "86790d9de17ae60219970440993760076df2d266fde4fd488ae5b1881f11647d"
    sha256 cellar: :any, catalina:       "aff5ebf8a1f0b663f02f1377a1cc0f3ad8fdf34e6e855a955f91c7740daa9da3"
    sha256               x86_64_linux:   "5473c1cb1fd3041e69e80bdff319c5955b9aac6759ccacfa082b10ea199f417f"
  end

  depends_on "python@3.10" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "scalapack"

  on_linux do
    depends_on "openblas"
  end

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https://github.com/cp2k/libint-cp2k/releases/download/v2.6.0/libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    resource("libint").stage do
      ENV.append "FCFLAGS", "-fPIE" if OS.linux?
      system "./configure", "--prefix=#{libexec}", "--enable-fortran"
      system "make"
      ENV.deparallelize { system "make", "install" }
    end

    arch = "local"
    if OS.mac?
      arch = "Darwin-gfortran"

      # libint needs `-lstdc++` (https://github.com/cp2k/cp2k/blob/master/INSTALL.md)
      # Can remove if added upstream to Darwin-gfortran.psmp and Darwin-gfortran.ssmp
      libs = %W[
        -L#{Formula["fftw"].opt_lib}
        -lfftw3
        -lstdc++
      ]

      ENV["LIBXC_INCLUDE_DIR"] = Formula["libxc"].opt_include
      ENV["LIBXC_LIB_DIR"] = Formula["libxc"].opt_lib
      ENV["LIBINT_INCLUDE_DIR"] = libexec/"include"
      ENV["LIBINT_LIB_DIR"] = libexec/"lib"

      # CP2K configuration is done through editing of arch files
      inreplace Dir["arch/Darwin-gfortran.*"].each do |s|
        s.gsub!(/DFLAGS *=/, "DFLAGS = -D__FFTW3")
        s.gsub!(/FCFLAGS *=/, "FCFLAGS = -I#{Formula["fftw"].opt_include}")
        s.gsub!(/LIBS *=/, "LIBS = #{libs.join(" ")}")
      end

      # MPI versions link to scalapack
      inreplace Dir["arch/Darwin-gfortran.p*"],
                /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_lib}"

      # OpenMP versions link to specific fftw3 library
      inreplace Dir["arch/Darwin-gfortran.*smp"],
                "-lfftw3", "-lfftw3 -lfftw3_threads"
    else
      args = %W[
        -j #{ENV.make_jobs}
        --mpi-mode=openmpi
        --math-mode=openblas
        --with-gcc=system
        --with-intel=no
        --with-cmake=no
        --with-openmpi=#{Formula["open-mpi"].opt_prefix}
        --with-mpich=no
        --with-intelmpi=no
        --with-libxc=#{Formula["libxc"].opt_prefix}
        --with-libint=#{libexec}
        --with-fftw=#{Formula["fftw"].opt_prefix}
        --with-acml=no
        --with-mkl=no
        --with-openblas=#{Formula["openblas"].opt_prefix}
        --with-scalapack=#{Formula["scalapack"].opt_prefix}
        --with-libxsmm=no
        --with-elpa=no
        --with-ptscotch=no
        --with-superlu=no
        --with-pexsi=no
        --with-quip=no
        --with-plumed=no
        --with-sirius=no
        --with-gsl=no
        --with-libvdwxc=no
        --with-spglib=no
        --with-hdf5=no
        --with-spfft=no
        --with-spla=no
        --with-cosma=no
        --with-libvori=no
      ]
      args << "--generic" if build.bottle?

      cd "tools/toolchain" do
        # Need OpenBLAS source to get proc arch info in scripts/get_openblas_arch.sh
        Formula["openblas"].stable.stage Pathname.pwd/"build/OpenBLAS"

        system "./install_cp2k_toolchain.sh", *args
        (buildpath/"arch").install (Pathname.pwd/"install/arch").children
      end
    end

    # Now we build
    %w[ssmp psmp].each do |exe|
      system "make", "ARCH=#{arch}", "VERSION=#{exe}"
      bin.install "exe/#{arch}/cp2k.#{exe}"
      bin.install "exe/#{arch}/cp2k_shell.#{exe}"
    end

    (pkgshare/"tests").install "tests/Fist/water512.inp"
  end

  test do
    system bin/"cp2k.ssmp", pkgshare/"tests/water512.inp"
    system "mpirun", bin/"cp2k.psmp", pkgshare/"tests/water512.inp"
  end
end
