class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9820e001f854b3d5abe3b95b5e63c2b787bd4a7f85c4ba43c5a97300372a802"
    sha256 cellar: :any,                 arm64_monterey: "a47234983881d433a2faedf6aa3a4a0cc3b91d721ec7a8bd1b74dc955d14f81c"
    sha256 cellar: :any,                 arm64_big_sur:  "59c76cff991fdfec77df5cc9f37602121aeae8ee439eae23cc03c859715901fb"
    sha256 cellar: :any,                 monterey:       "ce5ad6df53ec5fb8aba61a1c79e86b47bc654f7dd9876106b6335e3b168e790a"
    sha256 cellar: :any,                 big_sur:        "b4134737cce9b830e05099a4e06b00f9cac4bb21f313bb6279212973bc55611a"
    sha256 cellar: :any,                 catalina:       "5ad3c14fb4b94cf2c7af7fefcdc7b722bce43fabc5c1970dc3711134cd51e29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c5edbed6486f675ed338979bad134f8537ae21e0ca784234295a0e3d1ef0e0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hdf5"

  resource("homebrew-dataset") do
    url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
    sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
  end

  # Fix for Linux build: https://bugs.gentoo.org/652594
  # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
  patch do
    on_linux do
      url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
      sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
    end
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
