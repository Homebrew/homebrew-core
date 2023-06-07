class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.38/ns-3-dev-ns-3.38.tar.gz"
  sha256 "93dcb5b140289aed242cb7db8a3ca52b7c0a4c0bb0e09c4eed9e447487576166"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "466ce5ab86ae921f37fd80365f2bae6d0709753e020016b7ea0b6922b92e9517"
    sha256 cellar: :any,                 arm64_monterey: "e4ecd9d999f92e2e631bbfe220e2ae47f01ee285d7a8c40fd0821c6ddf978288"
    sha256 cellar: :any,                 arm64_big_sur:  "47e35b33f07fcab8d697aeb79a0ec786f23f9bad826867448dd58fc49f79049c"
    sha256 cellar: :any,                 ventura:        "83363cc43df063e78718de2933192980e95ed1b018f8737f72d2f7332b4cc7d0"
    sha256 cellar: :any,                 monterey:       "d4ad119ad0b87778c333688d687a50e3f9ef950e18484d017bb030fbea6ddb34"
    sha256 cellar: :any,                 big_sur:        "370021cec704c07371a236d0d1f95db10491dd4a82185e230d06904240212f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fe98517ace66418dc8532a44c8a96de4ef17c73b96f00f5408a35217bca784"
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
