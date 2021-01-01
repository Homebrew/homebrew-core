class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/mariusmuja/flann"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  license "BSD-3-Clause"
  revision 10

  bottle do
    cellar :any
    rebuild 1
    sha256 "d8e10f25b888a78bf0d16900c37f2acfec0a3e2131c22c02a4de8b0d0983ae3d" => :big_sur
    sha256 "ce67c71c2ab07f777a5d8fe7accd1cbb6d77e12d51b65fbc627071e57a73efc8" => :arm64_big_sur
    sha256 "a57044aa842d90b739c5008fa0d40d081afc68f8a390a93b59abc1f2e9e79b62" => :catalina
    sha256 "ac3439865022716c8db18d6af7ab44d74e4eb98e161c426a68cf52156e54e106" => :mojave
    sha256 "e8cd82ec90abf1dc403b7d364c638c43ed46036d81fb053e4cdc3b48967d3d3e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    # Fix for Linux build: https://bugs.gentoo.org/652594
    # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
    patch do
      url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
      sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
    end
  end

  resource("dataset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.dat"
    sha256 "dcbf0268a7ff9acd7c3972623e9da722a8788f5e474ae478b888c255ff73d981"
  end

  resource("testset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/testset.dat"
    sha256 "d9ff91195bf2ad8ced78842fa138b3cd4e226d714edbb4cb776369af04dda81b"
  end

  resource("dataset.hdf5") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.hdf5"
    sha256 "64ae599f3182a44806f611fdb3c77f837705fcaef96321fb613190a6eabb4860"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset.dat").stage testpath
    resource("testset.dat").stage testpath
    resource("dataset.hdf5").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
