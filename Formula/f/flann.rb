class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0fab1e551748ea6c3baca0dc9d9ce5655a44f95129bc2c6cb7f6c9aa5b30be2e"
    sha256 cellar: :any,                 arm64_ventura:  "d423c6646420608d8d584b103e4cbc256f9d50238d586552df14bafa52487b2f"
    sha256 cellar: :any,                 arm64_monterey: "747545821546c23623ec802d3c164e4f181624f3a1d15e644042849906bdfb7e"
    sha256 cellar: :any,                 arm64_big_sur:  "8712a0e27d6f169930b9ac66f82c904b7dece00c62ed467ce437a6d8e5109373"
    sha256 cellar: :any,                 sonoma:         "f3d6620ad52a9f87af013e11c0658255a6afd6bbe27832f119262ca68166c8b5"
    sha256 cellar: :any,                 ventura:        "ad4d33f860f42a3a4d21f803795ad2b3e96098eebbe7070644bb8743c131facc"
    sha256 cellar: :any,                 monterey:       "5ce0d7afdeb2958245953b190782f4e3db5b952d1ded939c82f17f419486cd1a"
    sha256 cellar: :any,                 big_sur:        "7aa9a99700760a0314c74bdb96c86538fce13444f30be5d1f53ce1ff9700adbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be54a5e51865769fec93930f2a596c899bc451e4cbde4c4e139a0c1e8ce6e304"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hdf5"

  resource "homebrew-dataset" do
    url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
    sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_PYTHON_BINDINGS:BOOL=OFF",
                    "-DBUILD_MATLAB_BINDINGS:BOOL=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-dataset").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
