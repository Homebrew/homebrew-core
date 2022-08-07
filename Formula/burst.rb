class Burst < Formula
  desc "Radix sort, lazy ranges and iterators, and more. Boost-like header-only library"
  homepage "https://github.com/izvolov/burst"
  url "https://github.com/izvolov/burst/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "12089244b7dbb26c3198f2ea5b80555050c38efe0a33ce4de4c1fff9b1e7532d"
  license "BSL-1.0"
  head "https://github.com/izvolov/burst.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "boost"

  def install
    cmake_args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Release"]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build", "--target", "check"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.8.2)
      project(TestBurst)
      find_package(Burst 3.1.0 REQUIRED)

      add_executable(test_burst test_burst.cpp)
      target_link_libraries(test_burst PRIVATE Burst::burst)
    EOS
    (testpath/"test_burst.cpp").write <<~EOS
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
    EOS
    cmake_args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Debug"]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build", "--target", "test_burst"
    system "build/test_burst"
  end
end
