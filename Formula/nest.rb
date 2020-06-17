class Nest < Formula
  desc "The Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v2.20.0.tar.gz"
  sha256 "40e33187c22d6e843d80095b221fa7fd5ebe4dbc0116765a91fc5c425dd0eca4"

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libomp"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.8"
  depends_on "readline"
  depends_on "scipy"

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end
  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

    libomp = Formula["libomp"]
    args << "-Dwith-python=3"
    args << "-Dwith-openmp=ON"
    args << "-Dwith-libraries=#{libomp.opt_lib}/libomp.dylib"
    args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    python_exec = "python3"

    python_version = Language::Python.major_minor_version(python_exec)
    bundle_path = libexec/"lib/python#{python_version}/site-packages"
    bundle_path.mkpath

    resource("nose").stage do
      system python_exec, *Language::Python.setup_install_args(libexec)
    end
    resource("six").stage do
      system python_exec, *Language::Python.setup_install_args(libexec)
    end
    ENV.prepend_create_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", bundle_path

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      system "make", "installcheck"
    end

    # Replace internally accessible gcc with externally accesible version
    # in nest-config if required
    inreplace bin/"nest-config",
        %r{#{HOMEBREW_REPOSITORY}/Library/Homebrew/shims.*/super},
        "#{HOMEBREW_PREFIX}/bin"
  end

  def caveats
    python = Formula["python@3.8"]
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.8 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{python.bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    python = Formula["python@3.8"]
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system python.bin/"python3.8", "-c", "'import nest'"
  end
end
