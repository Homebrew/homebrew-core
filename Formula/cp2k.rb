class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v8.2.0/cp2k-8.2.tar.bz2"
  sha256 "2e24768720efed1a5a4a58e83e2aca502cd8b95544c21695eb0de71ed652f20a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1e8685848a4ecfafb4174a5efe06f50d09d40ff15f2be857bcdcd6107537a18b"
    sha256 cellar: :any, big_sur:       "39aa87e7eaecb9eeda029c243e46a4e06ac55290b7c0f4ac412d2db920257747"
    sha256 cellar: :any, catalina:      "6047da892ce42081ea33d78a733f48f76c85dd93a07acadf896d7ae6cb33f147"
    sha256 cellar: :any, mojave:        "595431e7d8e76f526ae482074b49666d2b59e18feef73ed39d59b61bc669b01b"
  end

  depends_on "python@3.9" => :build
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
              /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_prefix}/lib"

    # OpenMP versions link to specific fftw3 library
    inreplace Dir["arch/Darwin-gfortran.*smp"],
              "-lfftw3", "-lfftw3 -lfftw3_threads"

    # Now we build
    %w[ssmp psmp].each do |exe|
      # Issue with parallel build: https://github.com/cp2k/cp2k/issues/1316
      ENV.deparallelize { system "make", "ARCH=Darwin-gfortran", "VERSION=#{exe}" }
      bin.install "exe/Darwin-gfortran/cp2k.#{exe}"
      bin.install "exe/Darwin-gfortran/cp2k_shell.#{exe}"
    end

    (pkgshare/"tests").install "tests/Fist/water512.inp"
  end

  test do
    system "#{bin}/cp2k.ssmp", "#{pkgshare}/tests/water512.inp"
    system "mpirun", "#{bin}/cp2k.psmp", "#{pkgshare}/tests/water512.inp"
  end
end
