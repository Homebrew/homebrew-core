class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.39/ns-3-dev-ns-3.39.tar.gz"
  sha256 "99be388a851fb5fa01f25c814fafef3d3d989d9a932f04374bf7bcc31cf72924"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "425aa33224b1e9489e519ba617b14d89ade0f1f773d48f295628778a10f94417"
    sha256 cellar: :any,                 arm64_monterey: "a39ccabec24aa09e65a29cf07eef4ba7afe714dac5fe9c408306839745f9bab0"
    sha256 cellar: :any,                 arm64_big_sur:  "c8c0d0b83542f2b0556bc5d35b010792090b1fbd2ddbfc9f1f64bc488cb8d6d1"
    sha256 cellar: :any,                 ventura:        "8dc7444cc41497a4ff9f875b6b75d3b9bd7e897313c7e4583aed724a38b13f29"
    sha256 cellar: :any,                 monterey:       "f1355a3e689c8097dd70377c500295d47c45ed435fd3077821e57f43949b9489"
    sha256 cellar: :any,                 big_sur:        "b75eabe4098d7b7ef12a88cfae762a7a464d21524e56ec359068398342b83a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026abf308e4d4d0b1604e2fefd322972e07d3494d2693f132bc5585c7cdd479a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    system "cmake", "-S", ".", "-B", "build",
                    "-DNS3_GTK3=OFF",
                    "-DNS3_PYTHON_BINDINGS=OFF",
                    "-DNS3_MPI=ON",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/tutorial/first.cc"
  end

  test do
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++17", "-o", "test"
    system "./test"
  end
end
