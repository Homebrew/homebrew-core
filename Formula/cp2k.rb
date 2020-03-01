class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v7.1.0/cp2k-7.1.tar.bz2"
  sha256 "ccd711a09a426145440e666310dd01cc5772ab103493c4ae6a3470898cd0addb"

  bottle do
    rebuild 1
    sha256 "247b28b0c8d0e08cc57d9b16a5fd8c9c41a152438c85a8efcd635ee341c30737" => :catalina
    sha256 "76d87db4b212df1bed6f182dcd153e992f6867931a9301c0476dad7779e58f40" => :mojave
    sha256 "17e86c6091ddd949b6b637a545e030244f5e4cc3b45b5b5bcadcc5d44830b383" => :high_sierra
  end

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "scalapack"

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

    %w[sopt ssmp popt psmp].each do |exe|
      system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=#{exe}"
      bin.install "../exe/Darwin-IntelMacintosh-gfortran/cp2k.#{exe}"
      bin.install "../exe/Darwin-IntelMacintosh-gfortran/cp2k_shell.#{exe}"
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
