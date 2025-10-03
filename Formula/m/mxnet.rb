class Mxnet < Formula
  desc "Flexible and efficient library for deep learning"
  homepage "https://mxnet.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  mirror "https://archive.apache.org/dist/incubator/mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  sha256 "11ea61328174d8c29b96f341977e03deb0bf4b0c37ace658f93e38d9eb8c9322"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e1e944d4b346f4dd124237e0310c8aded1710c1e49e56b50d43a8e35c503271"
    sha256 cellar: :any,                 arm64_ventura:  "2020a5335652d0b125527493362fcdfc82401f4138cc5f858839bf8fa3c89d8d"
    sha256 cellar: :any,                 arm64_monterey: "8c36d0a7729bd0dd148c0d5aa2be116a47bbbf348d5bfcde162ce218cf44cf62"
    sha256 cellar: :any,                 arm64_big_sur:  "49a4ca9dc8f9286aeb6c8607645f41b2196d529c6cd1ddba0dd3d1219b3466e2"
    sha256 cellar: :any,                 sonoma:         "0b9891959f9298eeecdbac5438471f6b7e4a28b0531a611244644c2528f9a4c0"
    sha256 cellar: :any,                 ventura:        "1ca1366b1c0906568e79e7a0fc07ed6a162e88773dc96296ee61f20689f4cf42"
    sha256 cellar: :any,                 monterey:       "3e253dbc7e037089f0d3fe8151e7eea4f49754dbc068bdfe8ec67416f57fafec"
    sha256 cellar: :any,                 big_sur:        "54b4463862a820006c4127226fc4f9284856fe4c4754fbc8ab2bc2ec3edf277b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbcaa399628827097bd18a797cd6dd7f10df7950eac62564143edc818967156"
  end

  # Moved into the Attic in 2023-09: https://attic.apache.org/projects/mxnet.html
  disable! date: "2025-01-05", because: :deprecated_upstream

  depends_on "cmake" => :build
  depends_on "openblas"
  depends_on "opencv"

  uses_from_macos "python" => :build

  def install
    args = [
      "-DBUILD_CPP_EXAMPLES=OFF",
      "-DUSE_CCACHE=OFF",
      "-DUSE_CPP_PACKAGE=ON",
      "-DUSE_CUDA=OFF",
      "-DUSE_MKLDNN=OFF",
      "-DUSE_OPENMP=OFF",
    ]
    args << "-DUSE_SSE=OFF" if Hardware::CPU.arm?
    system "cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "cpp-package/example"
  end

  test do
    cp pkgshare/"example/test_kvstore.cpp", testpath
    system ENV.cxx, "-std=c++11", "-o", "test", "test_kvstore.cpp",
                    "-I#{include}", "-L#{lib}", "-lmxnet"
    system "./test"
  end
end
