class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v6.1.0/cp2k-6.1.tar.bz2"
  sha256 "af803558e0a6b9e9d9ce8a3ab955ba32bacd179922455424e061c82c9fefa34b"
  license "GPL-2.0"
  revision 3

  bottle do
    sha256 arm64_big_sur: "32eb4f7cffffe7f0690918d5d0d112d3d914c623b9a22cf56845c7a2b917eb49"
    sha256 big_sur:       "53e46178fc2fc84eb58ffd165aac614bc2cb6912145b40d4447716245b4234bc"
    sha256 catalina:      "5d329a2fa68e818f75237fefd4749a590c115a4ca1330fd20782c49fd0b9793d"
    sha256 mojave:        "9b05551c6ba11e1f7144c23ca35d687793cb0fa219c7fb4fc4d55aa7ea793c5a"
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

  # Upstream fix for GCC 10, remove in next version
  # https://github.com/cp2k/dbcsr/commit/fe71e6fe
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/0c086813/cp2k/gcc10.diff"
    sha256 "dfaa319c999d49faae86cafe58ddb3b696f72a89f7cc85acd47b3288c6b9ac89"
  end

  def install
    resource("libint").stage do
      system "./configure", "--prefix=#{libexec}"
      system "make"
      ENV.deparallelize { system "make", "install" }
    end

    # -fallow-argument-mismatch should be removed when the issue is fixed:
    # https://github.com/cp2k/cp2k/issues/969
    fcflags = %W[
      -I#{Formula["fftw"].opt_include}
      -I#{libexec}/include
      -fallow-argument-mismatch
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
      s.gsub!(/DFLAGS *=/, "DFLAGS = -D__FFTW3")
      s.gsub!(/FCFLAGS *=/, "FCFLAGS = #{fcflags.join(" ")}")
      s.gsub!(/LIBS *=/, "LIBS = #{libs.join(" ")}")
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
