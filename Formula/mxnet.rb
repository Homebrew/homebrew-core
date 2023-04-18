class Mxnet < Formula
  desc "Flexible and efficient library for deep learning"
  homepage "https://mxnet.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  mirror "https://archive.apache.org/dist/incubator/mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  sha256 "11ea61328174d8c29b96f341977e03deb0bf4b0c37ace658f93e38d9eb8c9322"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f65d788203a541ed82b1dfaa024ff6965e5aee8a84aafc79984d532e9299df79"
    sha256 cellar: :any,                 arm64_monterey: "72f78cde6aa662400f4ec403c630674fb9cdd8c0f1812c8294c7da7f395a52c5"
    sha256 cellar: :any,                 arm64_big_sur:  "1c0529a20a2f9bb5e7b0a0d505f7d393e9fc7687900d987162d5f1102dcb8958"
    sha256 cellar: :any,                 ventura:        "0ccf72880e4ac7c40346c8261d03a1d23330df71c7d41ee9d7f2472574aa2a3a"
    sha256 cellar: :any,                 monterey:       "5358a09e7f8a3712ff27abc2707470824747d3f1d64c70cb54aecb965724333a"
    sha256 cellar: :any,                 big_sur:        "a291380b912d157b922e40f9c6b1fa0a4974a81eb7843f32bc54c28c0712c3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b355fcd8bffac727b1a4716228d29e9ebdab0908ce7d8da48511fdf9a5eec6d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "openblas"
  depends_on "opencv"

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
