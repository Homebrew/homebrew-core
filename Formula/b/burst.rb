class Burst < Formula
  desc "Radix sort, lazy ranges and iterators, and more. Boost-like header-only library"
  homepage "https://github.com/izvolov/burst"
  url "https://github.com/izvolov/burst/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "ee58c7b98ca1709dd452b9ba46cb4c91fc0b2952edd020ed5bc2d600b3edeae7"
  license "BSL-1.0"
  head "https://github.com/izvolov/burst.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "aba413390562e5c52f5ebfc88bc53280094805ae1440081e2d3bcf54267c4586"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBURST_TESTING=OFF",
                    "-DBURST_BENCHMARKING=OFF",
                    *std_cmake_args
    # Skip `cmake --build build` to avoid running tests.
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.8.2)
      project(TestBurst)
      find_package(Burst 3.1.1 REQUIRED)

      add_executable(test_burst test_burst.cpp)
      target_link_libraries(test_burst PRIVATE Burst::burst)
    CMAKE
    (testpath/"test_burst.cpp").write <<~CPP
      #include <burst/algorithm/radix_sort/radix_sort_seq.hpp>

      #include <cassert>
      #include <string>
      #include <vector>

      int main ()
      {
          std::vector<std::string> strings{"aaaa", "bbb", "cc", "d"};

          std::vector<std::string> buffer(strings.size());
          burst::radix_sort(strings.begin(), strings.end(), buffer.begin(),
              [] (const std::string & string)
              {
                  return string.size();
              }
          );
          assert((strings == std::vector<std::string>{"d", "cc", "bbb", "aaaa"}));
      }
    CPP
    cmake_args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Debug"]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build", "--target", "test_burst"
    system "build/test_burst"
  end
end
