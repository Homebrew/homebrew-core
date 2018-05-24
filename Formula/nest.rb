class Nest < Formula
  desc "The Neural Simulation Tool (NEST) with Python2 bindings (PyNEST)"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v2.14.0.tar.gz"
  sha256 "afaf7d53c2d5305fac1257759cc0ea6d62c3cebf7d5cc4a07d4739af4dbb9caf"

  bottle do
    sha256 "4f7d765cd75ae3272ce15bb293c20a6cdfc9ccb551f0a07d00016c75ae0ef267" => :high_sierra
    sha256 "60e4b0595c5d11003ffe1eca3fdca3c197b8711336ead21eba67620db96454c0" => :sierra
    sha256 "8a4c8e6d0d2e4ce93d76af73197c693f8c303095800e82b7266b922848f1a39b" => :el_capitan
    sha256 "6207dea13f90b17a95313b964323f7971cd5e2507a38b0ffd5d64b2f346e7851" => :x86_64_linux
  end

  # Add patches for matplotlib removal in upstream:
  patch do
    url "https://github.com/nest/nest-simulator/commit/b7f3313c0558da0da269cd7a11cc657da2049df7.patch?full_index=1"
    sha256 "54588322953d0dbc02a036053cdca7ad47153eb46464ce471579adb0f958277d"
  end

  patch do
    url "https://github.com/nest/nest-simulator/commit/d60e189123b994764bef8179aa91b4b001dad1dd.patch?full_index=1"
    sha256 "44c14588c1b9b8fcc67326c4119e8d42c8a069670630eab5a1522daac2219708"
  end

  patch do
    url "https://github.com/nest/nest-simulator/commit/5cfa2a77a060eae0f90182c56c42bdc8549dd19c.patch?full_index=1"
    sha256 "69e4d642555a7abefc65dc287d48715ffb42faac72e1ff3dfb880fda58564045"
  end

  option "with-python", "Build Python3 bindings (PyNEST) instead of Python2 bindings."

  depends_on "cmake" => :build
  depends_on "libtool" => :run
  depends_on "gcc" # scipy, numpy require fortran
  depends_on "gsl"
  depends_on "readline"

  # Any Python >= 2.7 < 3.x is okay (either from macOS or brewed)
  # core only supports macOS and https://docs.brew.sh/Python-for-Formula-Authors.html#bindings
  depends_on "python" => :optional

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/ee/2a/c4d2cdd19c84c32d978d18e9355d1ba9982a383de87d0fcb5928553d37f4/Cython-0.27.3.tar.gz"
    sha256 "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/a3/99/74aa456fc740a7e8f733af4e8302d8e61e123367ec660cd89c53a3cd4d70/numpy-1.14.1.zip"
    sha256 "fa0944650d5d3fb95869eaacd8eedbd2d83610c85e271bd9d3495ffa9bc4dc9c"
  end

  resource "scipy" do
    url "https://github.com/scipy/scipy/releases/download/v1.0.0/scipy-1.0.0.tar.xz"
    sha256 "06b23f2a5db5418957facc86ead86b7752147c0461f3156f88a3da87f3dc6739"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    # The Homebrew site-packages path is automatically added to the PYTHONPATH
    # env var in Library/Homebrew/requirements/python_requirement.rb. However,
    # it is getting confused as to which version of Python we are using and
    # putting the wrong site-packages on the path (2 instead of 3). Since we
    # don't need any Homebrew-installed bindings it is easiest/safe just to
    # delete it.
    ENV.delete("PYTHONPATH")

    args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

    args << "-Dwith-openmp=OFF"

    if build.with? "python"
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
    bundle_path = libexec/"lib/python#{python_version}/site-packages"
    bundle_path.mkpath

    resource("nose").stage do
      system python_exec, *Language::Python.setup_install_args(libexec)
    end

    resource("numpy").stage do
      # see https://github.com/Homebrew/homebrew-core/blob/master/Formula/numpy.rb
      system python_exec, "setup.py",
        "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
        "install", "--prefix=#{libexec}",
        "--single-version-externally-managed", "--record=installed.txt"
    end

    resource("scipy").stage do
      # require numpy
      ENV.prepend_create_path "PYTHONPATH", bundle_path
      system python_exec, "setup.py",
        "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
        "install", "--prefix=#{libexec}",
        "--single-version-externally-managed", "--record=installed.txt"
    end
    (lib/"python#{python_version}/site-packages/homebrew-nest-dependencies.pth").write "#{bundle_path}\n"

    resource("Cython").stage do
      # is only a build dependency
      system python_exec, *Language::Python.setup_install_args(buildpath/"cython")
    end

    # Add local build resource Cython residing in buildpath to paths
    ENV.prepend_path "PATH", buildpath/"cython/bin"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{python_version}/site-packages"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Replace internally accessible gcc with externally accesible version
    # in nest-config if required
    inreplace bin/"nest-config",
        %r{#{HOMEBREW_REPOSITORY}/Library/Homebrew/shims.*/super},
        "#{HOMEBREW_PREFIX}/bin"
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

    # add nosetest executable to path
    ENV.prepend_create_path "PATH", libexec/"bin"
    # run all tests
    args = ["--test-pynest"]
    ENV["PYTHON"] = "python3" if build.with? "python3"

    system pkgshare/"extras/do_tests.sh", *args
  end
end
