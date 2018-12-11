class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v5.1.0/cp2k-5.1.tar.bz2"
  sha256 "e23613b593354fa82e0b8410e17d94c607a0b8c6d9b5d843528403ab09904412"
  revision 2

  bottle do
    sha256 "ad145bfd6e2388fcb2d9570b6470573290980fe849342b9366ffc812c042656b" => :mojave
    sha256 "203473746541add0010fb52680c36cd541b1ace79e90de200a980fe772c44b46" => :high_sierra
    sha256 "754a13384f62a38e102f2661e71cd3fe37c8e8c21b45812e72ba4daa994130c8" => :sierra
    sha256 "4e5abf5bafe177b02507a4275802bdaf3ae0a2b7b88edd59b8d423af6bdb3b79" => :el_capitan
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
