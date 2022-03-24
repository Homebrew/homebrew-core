class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  license "BSD-3-Clause"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7655dd941d2d9c595b2f04c35f8bd7f0e1a1faf513d01ff26084b8e1a2dc5b6"
    sha256 cellar: :any,                 arm64_big_sur:  "66fbccb32f9c000e4c9895a9e6289287ed80960bbbad550a54f02d434016edbe"
    sha256 cellar: :any,                 monterey:       "daae6ca168f1a9127c69d6c90a48f1b1eb65c3ac7e5d1c53290c221a98de6f5c"
    sha256 cellar: :any,                 big_sur:        "9ae192a790d2c63463152f30286818df10f66dc78b2f908631173bd9d20a303f"
    sha256 cellar: :any,                 catalina:       "c131f386424a08dedc3770a9364af7f8dcce5d70e3415bc87a09df6f82ad8399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31842ceba155505d9f6661afb37b091a3b6d49e51b66652566cdc43ad38a17c5"
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
