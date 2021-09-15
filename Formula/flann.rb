class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4f7bdd32f4a2e7e4ae1f9367585da94b5cdb6ede82dee359046ab5e6cf59efdd"
    sha256 cellar: :any,                 big_sur:       "33278f699e22bd607e44ba0d556e34ed492adb8bd5c73a1c414a7241423f8bf7"
    sha256 cellar: :any,                 catalina:      "ef260f54e418a03d2320369da486148caacc0c6d5697f00e6efdbda4116f00fb"
    sha256 cellar: :any,                 mojave:        "59a708f81108cbbb05e885ed2125437fdecb6d8dc91ad901b48c92641b4dc199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f5c8f11a5191d8418c20be00b5616c9717c832f0c79a9a997011bda3eaae1c"
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

  resource("dataset") do
    url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
    sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
