class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://www.cs.ubc.ca/research/flann/"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 5

  bottle do
    cellar :any
    sha256 "e37ff0a9e3f91a64e1385381231b5b2eb348adb53342fcf7874ba24d5e409fd6" => :mojave
    sha256 "afe4526a8147f967deb0499b9e3f63e9898e82f9904463852e00885311b4431b" => :high_sierra
    sha256 "41e6706b4e0523632ee9116f76d33f0b2ed54ce8941da8a8219227bd943b9a1e" => :sierra
    sha256 "ece27f1635df0469b200f62a026aa13a27b45ce62ddf1c3146c1933066a48ce2" => :el_capitan
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "python@2" => :optional
  depends_on "numpy" if build.with? "python@2"

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
    if build.with? "python@2"
      pyarg = "-DBUILD_PYTHON_BINDINGS:BOOL=ON"
    else
      pyarg = "-DBUILD_PYTHON_BINDINGS:BOOL=OFF"
    end

    system "cmake", ".", *std_cmake_args, pyarg
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
