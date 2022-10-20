class Mxnet < Formula
  desc "Flexible and efficient library for deep learning"
  homepage "https://mxnet.apache.org"
  url "https://dlcdn.apache.org/incubator/mxnet/1.9.1/apache-mxnet-src-1.9.1-incubating.tar.gz"
  sha256 "11ea61328174d8c29b96f341977e03deb0bf4b0c37ace658f93e38d9eb8c9322"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0809ee3424903bc424a597c64aac5516390713696e86e72967bae1788d56e6fe"
    sha256 cellar: :any,                 arm64_big_sur:  "7a146f853557f902868dbf26b943776a2556717e106ce68f26dcfaa6236cacfa"
    sha256 cellar: :any,                 monterey:       "b364fb1791caca2a4b892ad998fe9f7f309509f5695394aaf1379a3f1f477f95"
    sha256 cellar: :any,                 big_sur:        "133637a0ea33d4526c02a4dfbdb4e5bc32c5d12343cccaef179c59e0b106db23"
    sha256 cellar: :any,                 catalina:       "136988d22610e7efe67b8574f92adfc196a3d1b67abae10f859bf13e2497dffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caaccddea2c9c2d884985ce4837d3915ed0bf8ade7c6bf9c7ab2ca993ac03765"
  end

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
