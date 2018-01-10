class Cantera < Formula
  desc "chemical kinetics, thermodynamics, and transport process tool suite"
  homepage "https://github.com/Cantera/cantera"
  url "https://github.com/Cantera/cantera/archive/v2.3.0.tar.gz"
  sha256 "06624f0f06bdd2acc9c0dba13443d945323ba40f68a9d422d95247c02e539b57"
  head "https://github.com/cantera/cantera.git"
  # tag "chemistry"
  # doi "10.5281/zenodo.170284"

  bottle do
    sha256 "8e5df2d0c9e79c38653d56151d77aca0fda8bcf5fc66daab8b5008668f787a68" => :sierra
    sha256 "b983abe48d16cf8c0be4b4ca114766eac28e9705f7ce77fffca967dcc3af33f9" => :el_capitan
    sha256 "ad38326b63906ed692c51f5ccd9b2afbfa3832f8fe229d73b62964d0506498f4" => :yosemite
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-test", "Disable build-time testing (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "scons" => :build
  depends_on "fmt"
  depends_on "eigen" => :build
  depends_on "boost" => :build
  depends_on :python if OS.mac? && MacOS.version <= :snow_leopard
  depends_on "numpy"
  depends_on "graphviz" => :optional
  depends_on :python3 => :optional

  resource "Cython" do
    url "https://pypi.python.org/packages/2f/ae/0bb6ca970b949d97ca622641532d4a26395322172adaf645149ebef664eb/Cython-0.25.1.tar.gz"
    sha256 "e0941455769335ec5afb17dee36dc3833b7edc2ae20a8ed5806c58215e4b6669"
  end

  # Matlab doesn't work with Homebrew's SUNDIALS installation, so we need to
  # embed it instead
  resource "sundials" do
    url "https://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
    sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.7.0.tar.gz"
    sha256 "f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"
    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"cython") << "--no-cython-compile"
    end

    (buildpath/"ext/sundials").install resource("sundials")

    if build.with? "test"
      (buildpath/"ext/googletest").install resource("gtest")
    end

    build_args = ["prefix=#{prefix}",
                  "python_package=full",
                  "CC=#{ENV.cc}",
                  "CXX=#{ENV.cxx}",
                  "f90_interface=n",
                  "system_sundials=n",
                  "extra_inc_dirs=#{HOMEBREW_PREFIX}/include/eigen3"]

    matlab_path = ARGV.value("with-matlab")
    if matlab_path
      build_args << "matlab_path=" + matlab_path
    end

    build_args << "python3_package=" + (build.with?("python3") ? "y" : "n")

    scons "build", *build_args
    if build.with? "test"
      if !matlab_path
        scons "test"
      else
        # Matlab test stalls when run through Homebrew, so run other sub-tests explicitly
        scons "test-general", "test-thermo", "test-kinetics", "test-transport", "test-python2"
      end
    end
    scons "install"
  end

  test do
    pythons = ["python"]
    pythons << "python3" if build.with? "python3"
    pythons.each do |python|
      system(python, "-m", "unittest", "-v", "cantera.test")
    end
  end
end
