class Cantera < Formula
  desc "Chemical kinetics, thermodynamics, and transport tool suite"
  homepage "https://cantera.org"
  url "https://github.com/Cantera/cantera/archive/v2.4.0.tar.gz"
  sha256 "012da50fa1aabf0cd8f5204f96977eefcfd6efd9794d95a56d64c86e0202a3d6"
  head "https://github.com/Cantera/cantera.git"

  option "with-matlab=", "Path to Matlab root directory"
  option "without-test", "Disable build-time testing (not recommended)"
  option "with-minimal", "Only build the minimal Python interface necessary to convert input files. Recommended when only the Matlab interface is desired"

  depends_on "boost" => :build
  depends_on "eigen" => :build
  depends_on "fmt" => :build
  depends_on "scons" => :build
  depends_on "python"
  depends_on "graphviz" => :optional
  depends_on "python@2" => :optional

  if build.with?("minimal") && build.with?("python@2")
    odie "The with-minimal and with-python@2 options are incompatible, only the full Python 2 interface can be installed from this formula."
  elsif build.with?("python@2")
    depends_on "numpy" => "with-python@2"

    resource "3to2" do
      url "https://files.pythonhosted.org/packages/8f/ab/58a363eca982c40e9ee5a7ca439e8ffc5243dde2ae660ba1ffdd4868026b/3to2-1.1.1.zip"
      sha256 "fef50b2b881ef743f269946e1090b77567b71bb9a9ce64b7f8e699b562ff685c"
    end
  elsif build.without?("minimal")
    depends_on "numpy" => "without-python@2"
  end

  # Cython is only needed for the full Python interface.
  if build.without?("minimal")
    # Cython has to be done as a resource here because the official formula is only available for
    # Python 2. Note that we only need Cython in the build environment which is Python 3 by default.
    resource "Cython" do
      url "https://files.pythonhosted.org/packages/79/9d/dea8c5181cdb77d32e20a44dd5346b0e4bac23c4858f2f66ad64bbcf4de8/Cython-0.28.2.tar.gz"
      sha256 "634e2f10fc8d026c633cffacb45cd8f4582149fa68e1428124e762dbc566e68a"
    end
  end

  # Matlab doesn't work with Homebrew's SUNDIALS installation, so we need to
  # embed it instead.
  resource "sundials" do
    url "https://computation.llnl.gov/projects/sundials/download/sundials-3.1.1.tar.gz"
    sha256 "a24d643d31ed1f31a25b102a1e1759508ce84b1e4739425ad0e18106ab471a24"
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    py_ver = Language::Python.major_minor_version("#{HOMEBREW_PREFIX}/bin/python3")

    # Cython is only needed for the full Python interface.
    if build.without?("minimal")
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{py_ver}/site-packages"
      resource("Cython").stage do
        system "#{HOMEBREW_PREFIX}/bin/python3", *Language::Python.setup_install_args(libexec) << "--no-cython-compile"
      end

      # 3to2 is only needed to convert examples for Python 2
      if build.with?("python@2")
        py2_ver = Language::Python.major_minor_version("#{HOMEBREW_PREFIX}/bin/python2")
        ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{py2_ver}/site-packages"
        resource("3to2").stage do
          system "#{HOMEBREW_PREFIX}/bin/python2", *Language::Python.setup_install_args(libexec)
        end
      end

    end

    (buildpath/"ext/sundials").install resource("sundials")

    (buildpath/"ext/googletest").install resource("gtest") if build.with? "test"

    build_args = ["prefix=#{prefix}",
                  "CC=#{ENV.cc}",
                  "CXX=#{ENV.cxx}",
                  "f90_interface=n",
                  "system_sundials=n",
                  "system_fmt=y",
                  "system_eigen=y",
                  "googletest=submodule",
                  "extra_inc_dirs=#{HOMEBREW_PREFIX}/include/eigen3",
                  "VERBOSE=y"]

    matlab_path = ARGV.value("with-matlab")
    build_args << "matlab_path=" + matlab_path if matlab_path

    build_args << "python3_package=" + (build.with?("minimal") ? "minimal" : "full")
    build_args << "python3_cmd=#{HOMEBREW_PREFIX}/bin/python3"

    build_args << "python2_package=" + (build.with?("python@2") ? "full" : "none")
    build_args << "python2_cmd=" + (build.with?("python@2") ? "#{HOMEBREW_PREFIX}/bin/python2" : "")

    system "#{HOMEBREW_PREFIX}/bin/python3", "#{HOMEBREW_PREFIX}/bin/scons", "build", *build_args, "-j#{ENV.make_jobs}"
    if build.with? "test"
      if !matlab_path
        system "#{HOMEBREW_PREFIX}/bin/python3", "#{HOMEBREW_PREFIX}/bin/scons", "test"
      else
        # Matlab test stalls when run through Homebrew, so run other sub-tests explicitly
        system "#{HOMEBREW_PREFIX}/bin/python3", "#{HOMEBREW_PREFIX}/bin/scons", "test-general", "test-thermo", "test-kinetics", "test-transport"
      end
    end
    system "#{HOMEBREW_PREFIX}/bin/python3", "#{HOMEBREW_PREFIX}/bin/scons", "install"
  end

  test do
    if build.with?("minimal")
      system("#{bin}/ck2cti", "--help")
    else
      pythons = ["#{HOMEBREW_PREFIX}/bin/python3"]
      pythons << "#{HOMEBREW_PREFIX}/bin/python2" if build.with? "python@2"
      pythons.each do |python|
        system(python, "-m", "unittest", "-v", "cantera.test")
      end
    end
  end
end
