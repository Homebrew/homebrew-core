class Nest < Formula
  desc "The Neural Simulation Tool (NEST) with Python2 bindings (PyNEST)"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v2.14.0.tar.gz"
  sha256 "afaf7d53c2d5305fac1257759cc0ea6d62c3cebf7d5cc4a07d4739af4dbb9caf"
  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "4f7d765cd75ae3272ce15bb293c20a6cdfc9ccb551f0a07d00016c75ae0ef267" => :high_sierra
    sha256 "60e4b0595c5d11003ffe1eca3fdca3c197b8711336ead21eba67620db96454c0" => :sierra
    sha256 "8a4c8e6d0d2e4ce93d76af73197c693f8c303095800e82b7266b922848f1a39b" => :el_capitan
    sha256 "6207dea13f90b17a95313b964323f7971cd5e2507a38b0ffd5d64b2f346e7851" => :x86_64_linux
  end

  option "with-python3", "Build Python3 bindings (PyNEST) instead of Python2 bindings."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]

  # Any Python >= 2.7 < 3.x is okay (either from macOS or brewed)
  # core only supports macOS and https://docs.brew.sh/Python-for-Formula-Authors.html#bindings
  # suggest removing the depends_on :python alltogether, hence removing it..
  depends_on :python3 => :optional

  requires_py3 = []
  requires_py3 << "with-python3" if build.with? "python3"
  depends_on "numpy" => requires_py3
  depends_on "scipy" => requires_py3
  depends_on "matplotlib" => requires_py3

  depends_on "libtool" => :run
  depends_on "readline" => :run
  depends_on "cmake" => :build

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/ee/2a/c4d2cdd19c84c32d978d18e9355d1ba9982a383de87d0fcb5928553d37f4/Cython-0.27.3.tar.gz"
    sha256 "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  fails_with :clang do
    cause <<-EOS.undent
      Building NEST with clang is not stable. See https://github.com/nest/nest-simulator/issues/74 .
    EOS
  end

  def install
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    # The Homebrew site-packages path is automatically added to the PYTHONPATH
    # env var in Library/Homebrew/requirements/python_requirement.rb. However,
    # it is getting confused as to which version of Python we are using and
    # putting the wrong site-packages on the path (2 instead of 3). Since we
    # don't need any Homebrew-installed bindings it is easiest/safe just to
    # delete it.
    ENV.delete("PYTHONPATH")

    args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

    args << "-Dwith-mpi=ON" if build.with? "mpi"
    args << "-Dwith-openmp=OFF" if build.without? "openmp"
    args << "-Dwith-gsl=OFF" if build.without? "gsl"

    if build.with? "python3"
      args << "-Dwith-python=3"
      python_exec = "python3"
    else
      # default to python2 installation
      # this always links to the system python during nest installation,
      # which should not be a problem, as python2.7.10 (system py2 as of writing this)
      # is compatible with brewed python2.7+
      args << "-Dwith-python=ON"
      python_exec = "python"
    end

    python_version = Language::Python.major_minor_version(python_exec)

    resource("nose").stage do
      system python_exec, *Language::Python.setup_install_args(libexec/"nose")
      # only nose executable is interesting during testing - not adding a *.pth file
    end

    resource("Cython").stage do
      system python_exec, *Language::Python.setup_install_args(buildpath/"cython")
    end

    # Add local build resource Cython residing in buildpath to paths
    ENV.prepend_create_path "PATH", buildpath/"cython/bin"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{python_version}/site-packages"

    # "out of source" build
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Replace internally accessible gcc with externally accesible version
    # in nest-config if required
    inreplace bin/"nest-config",
        %r{#{HOMEBREW_REPOSITORY}/Library/Homebrew/shims.*/super},
        "#{HOMEBREW_PREFIX}/bin",
        FALSE
  end

  test do
    # simple check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # necessary for the python tests
    ENV["exec_prefix"] = prefix
    # if build.head? does not seem to work
    if !File.directory?(pkgshare/"sources")
      # Skip tests for correct copyright headers
      ENV["NEST_SOURCE"] = "SKIP"
    else
      # necessary for one regression on the sources
      ENV["NEST_SOURCE"] = pkgshare/"sources"
    end

    if build.with? "mpi"
      # we need the command /mpirun defined for the mpi tests
      # and since we are in the sandbox, we create it again
      nestrc = <<-EOS
        /mpirun
        [/integertype /stringtype /stringtype]
        [/numproc     /executable /scriptfile]
        {
         () [
          (mpirun -np ) numproc cvs ( ) executable ( ) scriptfile
         ] {join} Fold
        } Function def
      EOS
      File.open(ENV["HOME"]+"/.nestrc", "w") { |file| file.write(nestrc) }
    end

    # add nosetest executable to path
    ENV.prepend_create_path "PATH", libexec/"nose/bin"
    # run all tests
    args = ["--test-pynest"]

    ENV["PYTHON"] = "python3" if build.with? "python3"

    system pkgshare/"extras/do_tests.sh", *args
  end
end
