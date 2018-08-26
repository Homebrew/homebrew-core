class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://www.cs.ubc.ca/research/flann/"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 4

  bottle do
    cellar :any
    sha256 "40398c04b80cbb5d59a4387f1efb4ede7ee9516e5f996e165dd8132c6c8acad0" => :mojave
    sha256 "5f8c131f79f06edb6340b707ba999c20b2dc9b77bb2f47436dbddffb38e0dc31" => :high_sierra
    sha256 "ae8fc018e89e774c317af7fe27ec7e3b193cfc45c1252ddd796c38817d63fe2a" => :sierra
    sha256 "1b5f2d3f1e1cb483473871b6df9aba70900110e6888d45480d829a27f4600428" => :el_capitan
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
