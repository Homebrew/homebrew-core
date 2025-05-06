class Doctest < Formula
  desc "Feature-rich C++11/14/17/20/23 single-header testing framework"
  homepage "https://github.com/doctest/doctest"
  url "https://github.com/doctest/doctest/archive/refs/tags/v2.4.12.tar.gz"
  sha256 "73381c7aa4dee704bd935609668cf41880ea7f19fa0504a200e13b74999c2d70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a680aeecce8a2548b38121d6282e90d856eb76d4d371518c4a3cd65845158fb7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDOCTEST_WITH_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
