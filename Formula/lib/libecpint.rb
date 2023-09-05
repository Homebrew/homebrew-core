class Libecpint < Formula
  desc "Library for the efficient evaluation of integrals over effective core potentials"
  homepage "https://github.com/robashaw/libecpint"
  url "https://github.com/robashaw/libecpint/archive/v1.0.7.tar.gz"
  sha256 "e9c60fddb2614f113ab59ec620799d961db73979845e6e637c4a6fb72aee51cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a37e3014839b368a0355389c4e17a2346f8de13d1c5250edf4a0cc1736a3cd3b"
    sha256 cellar: :any,                 arm64_monterey: "5ae1945106a527cfb54aba12b540ac85feae706d216143389174aa7e1f6d12ed"
    sha256 cellar: :any,                 arm64_big_sur:  "0114bd3d35c87dcf7ad6e3c959992ae79091b654b7c8c87319d665f19770781b"
    sha256 cellar: :any,                 ventura:        "6398a4d761c21ae717b55a54eaeed406f66ebc4b2b4ca4916ed5c7c5f2df608e"
    sha256 cellar: :any,                 monterey:       "0201916caae92234c864e5bacdc8ad303a7891aa1c1d13d90707d62312ff2322"
    sha256 cellar: :any,                 big_sur:        "062187fb6ebb6b4f3b731333209d30703afeba6208e3cd2566f7053457a9820b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b702393f9dcb41836efdab31c913fe81437aa1724e8006e0abc14908badd2868"
  end

  depends_on "cmake" => :build
  depends_on "libcerf"
  depends_on "pugixml"
  depends_on "python@3.11"

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBECPINT_USE_CERF=ON",
      "-DLIBECPINT_BUILD_TESTS=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests/lib/api_test1/test1.cpp",
                     "tests/lib/api_test1/api_test1.output",
                     "include/testutil.hpp"
  end

  test do
    cp [pkgshare/"api_test1.output", pkgshare/"testutil.hpp"], testpath
    system ENV.cxx, "-std=c++11", pkgshare/"test1.cpp",
                    "-DHAS_PUGIXML", "-I#{include}/libecpint",
                    "-L#{lib}", "-lecpint", "-o", "test1"
    system "./test1"
  end
end
