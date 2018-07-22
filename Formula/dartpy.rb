class Dartpy < Formula
  desc "Python binding for DART"
  homepage "https://github.com/personalrobotics/dartpy/"
  url "https://github.com/personalrobotics/dartpy/archive/v0.0.3.tar.gz"
  sha256 "362994d6f76e353f062b44895bf83eb3bf2d30170e9207785e1877ce0a84385c"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "boost_eigen_numpy"
  depends_on "dartsim"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system python, "-c", "import dartpy"
  end
end
