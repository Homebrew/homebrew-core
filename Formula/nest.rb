class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.1.tar.gz"
  sha256 "5c11dd6b451c4c6bf93037bf29d5231c6c75a0e1a8863344f6fb9bb225f279ca"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "4360a0644a67b77a7f38c5024f590149358a596d73d75c1d5cb264d6cafb3ade"
    sha256 monterey:      "3b7ee8c63f2fecf4639911e74baa91ed3a66237ecc56790abc15d6d012ed6bd5"
    sha256 big_sur:       "5654dd09df57e301826de686012a935ddf37f25b2165c52daefbd20a58f6cbfb"
    sha256 catalina:      "f90518fa24a2f931a03e27baf400c421b358cb1a64f4d2a757059d3ffa093b72"
    sha256 mojave:        "845b603df3ce444c2b460eb07880c37e44c92afb5e38bfe04a2161161d6fecdc"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libomp"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "readline"

  def install
    args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

    libomp = Formula["libomp"]
    args << "-Dwith-openmp=ON"
    args << "-Dwith-libraries=#{libomp.opt_lib}/libomp.dylib"
    args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Replace internally accessible gcc with externally accessible version
    # in nest-config if required
    inreplace bin/"nest-config",
        %r{#{HOMEBREW_REPOSITORY}/Library/Homebrew/shims.*/super}o,
        "#{HOMEBREW_PREFIX}/bin"
  end

  def caveats
    python = Formula["python@3.9"]
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.9 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{python.bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    python = Formula["python@3.9"]
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system python.bin/"python3.9", "-c", "'import nest'"
  end
end
