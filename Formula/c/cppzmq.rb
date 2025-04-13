class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://www.zeromq.org"
  url "https://github.com/zeromq/cppzmq/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "c81c81bba8a7644c84932225f018b5088743a22999c6d82a2b5f5cd1e6942b74"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1be9fecbad4da621c4f608f0395efd58f1252f1898ea64620bdaf82a1b6fdc1e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "zeromq"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCPPZMQ_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.cpp", testpath
    system ENV.cxx, "-std=c++11", "hello_world.cpp", "-I#{include}",
                    "-L#{Formula["zeromq"].opt_lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
