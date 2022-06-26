class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 1
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d17c63abe49e756cbcfa88f2d97f5d8f30064ad225171e8dfaf8e51e9a719fdf"
    sha256 cellar: :any,                 arm64_big_sur:  "8018663da536a07ff3864df3d53efbca3c3e7283691062dde2765aa4988725ae"
    sha256 cellar: :any,                 monterey:       "93d8287c0897ea594a31c04f6400e5ae39cd5339c536b814b914a3446cfef10f"
    sha256 cellar: :any,                 big_sur:        "b025cc55d821bae9cdcc40714a2333f6919b2e6de461906f5bce5f1442d10ce4"
    sha256 cellar: :any,                 catalina:       "d14d40ccb7de9443d39658cac84e2287ef78602b443f94887165e780046a0cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae9cf1ca4f9aeecb69ac5f4e2cba3b36a9ef8c7cf22c03dad78338dd39b22ec"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
