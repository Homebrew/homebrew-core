class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2023.2/cp2k-2023.2.tar.bz2"
  sha256 "adbcc903c1a78cba98f49fe6905a62b49f12e3dfd7cedea00616d1a5f50550db"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "fa48eab0f75ea1e3aabce2b9e7f529844d9ccc4f8df184fe79cc3f22eb81b6e0"
    sha256 cellar: :any, arm64_ventura:  "542a2e362bf408de6339d11c5fa669ff2aaf19780648a3c44f38678a6bbf264c"
    sha256 cellar: :any, arm64_monterey: "28a35f321d8a3a705c882eb54964d4c212ff7112c7320b2ac56185097d45d9be"
    sha256 cellar: :any, arm64_big_sur:  "b82e5812fa861ed7578aa0d3ad0b9c0bd14c31654563d1c5a0f77c61e45c9d77"
    sha256 cellar: :any, sonoma:         "c6e440ce4626f7993753447d03063917ad0d032e5f4e97afc43821addce59b01"
    sha256 cellar: :any, ventura:        "5f82951b87c5f6b08b82e1bdd58ac34dda2f97cef530108d915b3ad01512de6c"
    sha256 cellar: :any, monterey:       "8635ec176cdf6215df2f86fba78bcedc33f10dda0bdb2ce96f618c072be6160a"
    sha256 cellar: :any, big_sur:        "d26512a39816dd2eb27106a8de91bc235b1976bd6c2bf0aadde38d2364b12832"
    sha256               x86_64_linux:   "4c08e213964457d98b4f4c37bbe3e64f2f30c02670c66fbc93e58f3bc43dbccb"
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
      # PR submitted: https://github.com/cp2k/cp2k/pull/2966
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
      inreplace Dir["arch/Darwin-gfortran.*"].to_a.each do |s|
        s.gsub!(/DFLAGS *=/, "DFLAGS = -D__FFTW3")
        s.gsub!(/FCFLAGS *=/, "FCFLAGS = -I#{Formula["fftw"].opt_include}")
        s.gsub!(/LIBS *=/, "LIBS = #{libs.join(" ")}")
      end

      # MPI versions link to scalapack
      inreplace Dir["arch/Darwin-gfortran.p*"].to_a,
                /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_lib}"

      # OpenMP versions link to specific fftw3 library
      inreplace Dir["arch/Darwin-gfortran.*smp"].to_a,
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

    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    system bin/"cp2k.ssmp", pkgshare/"tests/water.inp"
    system "mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
