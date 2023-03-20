class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2023.1/cp2k-2023.1.tar.bz2"
  sha256 "dff343b4a80c3a79363b805429bdb3320d3e1db48e0ff7d20a3dfd1c946a51ce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "518c383d46fee2cd8e1ae6bc13c01df2b708e7606d1c189fb1a5bebe5b268543"
    sha256 cellar: :any, arm64_monterey: "ffe51ba4d7d5716176f762cadfcf410ea1497bc5f4ff916eae3e49d8ca9ac451"
    sha256 cellar: :any, arm64_big_sur:  "2645e06859bd331c7bd077bb6c32719f734a87152c3baa931f9baf965111f1e1"
    sha256 cellar: :any, ventura:        "952914b796cdf6dc00a9d094987ca4d39e5d4252113ffbca73f13e5a10457752"
    sha256 cellar: :any, monterey:       "9a042bb29e150aaf33b180e4c7e7a74accf32fcd85f25393782a860b92e58b41"
    sha256 cellar: :any, big_sur:        "c4f3319a3aff80930f26e9e22f82720afcabf96cee2d57c6c2c09a775bc26e63"
    sha256               x86_64_linux:   "661c1a15d867f097c8d5a2cd869aca368087830dafca5d3cfa918de41face117"
  end

  depends_on "python@3.11" => :build
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
      args << "--target-cpu=generic" if build.bottle?

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
