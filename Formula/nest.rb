class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.2.tar.gz"
  sha256 "583d5725882ad5e8fd4fc7ffab425da97cbbb91fadbc327e940c184e8892b958"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "139e28c76e3b724158a3802836dcd8688941347788cab6400773e74bae677ea2"
    sha256 arm64_big_sur:  "044b541904f20ce27ff83db39bcba2578cf12b705003b6670a6e0049b84b2aec"
    sha256 monterey:       "ffa1e53cbb08940f1ea6e5e33866f1ca5adf2137cc2cbcc0ecf96c8a02e6f2a4"
    sha256 big_sur:        "34c639ade9ae898a8d7f05d04a907a70e797a3eb8211b94fc1971365b9683dbd"
    sha256 catalina:       "358c0c767fda81a036d23e73e9802f69bc82b73ec5e4a0162712a96ea6c2ab47"
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
