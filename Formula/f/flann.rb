class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95cc1c8ebe8089d9f3b3cddcc4121b8758f27746f54ccb2a4e14120d31bced00"
    sha256 cellar: :any,                 arm64_ventura:  "b2c90010e7196565617ad2eece7f618f9e6ee94546e9712d45949574a510bf88"
    sha256 cellar: :any,                 arm64_monterey: "72b11ab5cb95c3635aca8a29551ed61810a407fc03ab4cef01981c1edb5e8929"
    sha256 cellar: :any,                 sonoma:         "d9b4d3fc2e2bf9bfd4387ec0ebc63892946f32650cc6e6fc0428c80c46bb0de4"
    sha256 cellar: :any,                 ventura:        "c7530e21771003003ecbe1075341c8a2fbf6d126abee489b2c5531a8c4f46e0c"
    sha256 cellar: :any,                 monterey:       "226c0dc7a561f5860f667d2605fc9dfa22c535469eb9bc50ace723ed8f5a771b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b54ae5296e98088861829c1b4a0bb994dddcf666c5e5f90814a6bc291bdacd4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hdf5"
  depends_on "lz4"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_PYTHON_BINDINGS:BOOL=OFF",
                    "-DBUILD_MATLAB_BINDINGS:BOOL=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-dataset" do
      url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
      sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
    end

    testpath.install resource("homebrew-dataset")

    system bin/"flann_example_c"
    system bin/"flann_example_cpp"
  end
end
