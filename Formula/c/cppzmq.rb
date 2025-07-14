class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://www.zeromq.org"
  url "https://github.com/zeromq/cppzmq/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "0fff4ff311a7c88fdb76fceefba0e180232d56984f577db371d505e4d4c91afd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5aad9277c9ee7b3140a55c7602ffc5f2be20dd46ea77fcae0ca4bb75c47fb372"
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
