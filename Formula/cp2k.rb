class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2022.2/cp2k-2022.2.tar.bz2"
  sha256 "1a473dea512fe264bb45419f83de432d441f90404f829d89cbc3a03f723b8354"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "fcec80a4940fa50e97a5265b1c0130b8da6de936de63f680651ffa0b6bc7ff38"
    sha256 cellar: :any, arm64_big_sur:  "dc773c3a2db1fbb85b05017350d4bd41ceb706a3c30b1f9fe8ca7b8b485a2cee"
    sha256 cellar: :any, monterey:       "ecb630b488adb8101d713d8df4b7c8cd62a5ad1109c399765f9feb0931eaa775"
    sha256 cellar: :any, big_sur:        "fca867b107b90270435f1801503b714814aab4de125814201cc683d2ddfa0072"
    sha256 cellar: :any, catalina:       "9654f614b8d91870e85fe65cbc46d8db4bb3caa2e32a90b7b61659d2ad002bff"
    sha256               x86_64_linux:   "ce82e591f38c45e0bbc0ac943c2c073dc0963bdcc45f1192178b2e54ac5581fa"
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
