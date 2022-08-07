class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2022.1/cp2k-2022.1.tar.bz2"
  sha256 "2c34f1a7972973c62d471cd35856f444f11ab22f2ff930f6ead20f3454fd228b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2f1fa6d5a62af7f9714d31837435f398be4261f89c3b029e0db964faf4ce38d7"
    sha256 cellar: :any, arm64_big_sur:  "8bf7e70d9f2405197895a92b45a1921e0ea7f1f5df87a1c0b9c6a4dc3f5db3be"
    sha256 cellar: :any, monterey:       "ccce3f31bd5a7b7afcdb744598d35b379675e1638364490d2bc664124cad6065"
    sha256 cellar: :any, big_sur:        "376b2a21f32719844f1bbaec45989a4d188f90958808347f0f5b925fc2a2143c"
    sha256 cellar: :any, catalina:       "a23b005ee4bf3475c27af5c6a344b32c769465b949da0e2874ca0292220907ed"
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
