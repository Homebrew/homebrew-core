class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v8.2.0/cp2k-8.2.tar.bz2"
  sha256 "2e24768720efed1a5a4a58e83e2aca502cd8b95544c21695eb0de71ed652f20a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "ef6bb7c803d002b2137cdbc8ce2b84f7ae7be46f8a87fe8c82745722dbbf9e45"
    sha256 cellar: :any, arm64_big_sur:  "95a6fc3748ba6bd26e0d4aabd1d59f81e8e959b80852b58bf1be52297db4cfb4"
    sha256 cellar: :any, monterey:       "28a6583b2318c6d511782ecefa932693eadf0b67908aa3096c6b96a93c2bb3c6"
    sha256 cellar: :any, big_sur:        "10c351fabd61ce78659ae98e48b5e81eae9b4ca713269027e45253c4d49beaf4"
    sha256 cellar: :any, catalina:       "27878e3f33287a1a79d24888d3f688dbc4718515017e2862f683d2f05349b0e4"
    sha256 cellar: :any, mojave:         "4f020460fbca04eda6e50977c0fee89804a93a1eb11e2f0f4e7abd775b0be587"
  end

  depends_on "python@3.10" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "scalapack"

  on_linux do
    depends_on "gsl"
    depends_on "hdf5"
    depends_on "openblas"
  end

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https://github.com/cp2k/libint-cp2k/releases/download/v2.6.0/libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    # Issue with parallel build on macOS: https://github.com/cp2k/cp2k/issues/1316.
    ENV.deparallelize if OS.mac?

    resource("libint").stage do
      system "./configure", "--prefix=#{libexec}", "--enable-fortran"
      system "make"
      system "make", "install"
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
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"

    arch = OS.mac? ? "Darwin" : "#{OS.kernel_name}-#{Hardware::CPU.arch}"

    # CP2K configuration is done through editing of arch files
    inreplace Dir["arch/#{arch}-gfortran.*"].each do |s|
      s.gsub!(/DFLAGS *=/, "DFLAGS = -D__FFTW3")
      s.gsub!(/FCFLAGS *=/, "FCFLAGS = -I#{Formula["fftw"].opt_include}")
      s.gsub!(/LIBS *=/, "LIBS = #{libs.join(" ")}")
    end

    # MPI versions link to scalapack
    inreplace Dir["arch/#{arch}-gfortran.p*"],
              /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_prefix}/lib"

    # OpenMP versions link to specific fftw3 library
    inreplace Dir["arch/#{arch}-gfortran.*smp"],
              "-lfftw3", "-lfftw3 -lfftw3_threads"

    # Remove flags for unused dependencies on Linux.
    # The build system has been completely refactored upstream and
    # these manual fixes will not be needed in the next release.
    unless OS.mac?
      inreplace Dir["arch/#{arch}-gfortran.*smp"] do |s|
        s.gsub!("-D__LIBVORI", "")
        s.gsub!("-D__LIBXSMM", "")
        s.gsub!("-D__SPGLIB", "")

        s.gsub!("-I$(LIBXSMM_INC)", "")

        s.gsub!("$(LIBVORI_LIB)/libvori.a", "")
        s.gsub!("$(SPGLIB_LIB)/libsymspg.a", "")
        s.gsub!("$(LIBXSMM_LIB)/libxsmmf.a", "")
        s.gsub!("$(LIBXSMM_LIB)/libxsmm.a", "")
        s.gsub!("$(LIBPATH)/liblapack.a", "")

        s.gsub!("$(GNU_PATH)/fftw/3.3.9/include", Formula["fftw"].opt_include)
        s.gsub!("$(GNU_PATH)/fftw/3.3.9/lib", Formula["fftw"].opt_lib)
        s.gsub!("$(GNU_PATH)/libint/2.6.0-lmax-6", libexec)
        s.gsub!("$(GNU_PATH)/libxc/5.1.4/include", Formula["libxc"].opt_include)
        s.gsub!("$(GNU_PATH)/libxc/5.1.4/lib", Formula["libxc"].opt_lib)
      end

      inreplace "arch/#{arch}-gfortran.ssmp" do |s|
        s.gsub!("$(LIBPATH)/libblas.a", "#{Formula["openblas"].opt_lib}/libopenblas.a")
        s.gsub!("-static", "")
      end

      inreplace "arch/#{arch}-gfortran.psmp" do |s|
        s.gsub!("include       $(MPI_PATH)/plumed2/2.6.2/lib/plumed/src/lib/Plumed.inc.static", "")
        s.gsub!("-D__ELPA", "")
        s.gsub!("-D__PLUMED2", "")
        s.gsub!("-D__SIRIUS", "")
        s.gsub!("-D__SCALAPACK", "")

        s.gsub!("-I$(ELPA_INC)/elpa -I$(ELPA_INC)/modules", "")
        s.gsub!("-I$(SIRIUS_INC)", "")
        s.gsub!("-I$(SPGLIB_INC)", "")

        s.gsub!("$(PLUMED_DEPENDENCIES)", "")
        s.gsub!("$(ELPA_LIB)/libelpa_openmp.a", "")
        s.gsub!("${SIRIUS_LIB}/libsirius.a", "")
        s.gsub!("$(GNU_PATH)/SpFFT/0.9.13/lib/libspfft.a", "")
        s.gsub!("$(GNU_PATH)/SpLA/1.2.1/lib/libspla.a", "")
        s.gsub!("$(GNU_PATH)/hdf5/1.12.0/lib/libhdf5.a", "#{Formula["hdf5"].opt_lib}/libhdf5.a")
        s.gsub!("$(GNU_PATH)/OpenBLAS/0.3.15/lib/libopenblas.a",
                "#{Formula["openblas"].opt_lib}/libopenblas.a")
        s.gsub!("$(LIBPATH)/libz.a", "#{Formula["zlib"].opt_lib}/libz.a")
        s.gsub!("$(MPI_LIBRARY_PATH)/libscalapack.a", "")
      end
    end

    # Now we build
    %w[ssmp psmp].each do |exe|
      args = %W[
        ARCH=#{arch}-gfortran
        VERSION=#{exe}
      ]
      args << "GSL_LIBRARY_DIR=#{Formula["gsl"].opt_lib}" unless OS.mac?
      system "make", *args

      bin.install "exe/#{arch}-gfortran/cp2k.#{exe}"
      bin.install "exe/#{arch}-gfortran/cp2k_shell.#{exe}"
    end

    (pkgshare/"tests").install "tests/Fist/water512.inp"
  end

  test do
    cp pkgshare/"tests/water512.inp", testpath
    # Only run 2 steps on Linux because OpenBLAS is very slow in Docker and
    # the test will timeout if all 20 iterations are run.
    inreplace "water512.inp", "STEPS 20", "STEPS 2" unless OS.mac?
    system bin/"cp2k.ssmp", "water512.inp"
    system "mpirun", bin/"cp2k.psmp", "water512.inp"
  end
end
