class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce039aafb94888067fa1b6635545ed4c234374b3aeee0556a73945e0276bd6a5"
    sha256 cellar: :any,                 arm64_monterey: "416a6d12b6f2f09b81cd308c9a58b0d8cd1d88e96ff362b4fa5c9f838c989ba1"
    sha256 cellar: :any,                 arm64_big_sur:  "2d63354a2309399fade02df0b1c4016ed0e1fc6cb2dffc5955e48111c10f3059"
    sha256 cellar: :any,                 ventura:        "4b5f574e410495b07fd1a415d13fc15468fbe4dec2aa3ee2391300f5853bdb7e"
    sha256 cellar: :any,                 monterey:       "a0b89125c02471a385f1743c6ece3507b701a626553e37ecdd494e2616315b7c"
    sha256 cellar: :any,                 big_sur:        "4d9fd8b2d6e4665200bea9d2ca99b19445f26fc1463c15e1f50ad637f3bc26db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ddf0c740659af08afca13721fe5ff82ad670cd83827f9ab412a08c081fb43f"
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
