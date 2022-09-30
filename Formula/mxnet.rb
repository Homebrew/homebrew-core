class Mxnet < Formula
  desc "Flexible and efficient library for deep learning"
  homepage "https://mxnet.apache.org"
  url "https://dlcdn.apache.org/incubator/mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  sha256 "11ea61328174d8c29b96f341977e03deb0bf4b0c37ace658f93e38d9eb8c9322"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
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
