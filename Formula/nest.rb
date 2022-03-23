class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.3.tar.gz"
  sha256 "179462b966cc61f5785d2fee770bc36f86745598ace9cd97dd620622b62043ed"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "79980487fd0ed24002a4ff53f6bcc07b0d5238069e101e419c6322414d710add"
    sha256 arm64_big_sur:  "37c157798ba38e922c6a6d24abeb7244f99170b21972b38d9dad45470894f32a"
    sha256 monterey:       "40c3f23231b04a2dc90c0c075e0180dce0f1809903a298c33f7c8795040724c4"
    sha256 big_sur:        "088cd5b26ef3658e34a22143c8858a927d26f0954f692cc8787f7426cca64c6d"
    sha256 catalina:       "007670f4a858fc98ac500bd49e4df64787bd7c5d7049bd69dae5f4d459d332ae"
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
