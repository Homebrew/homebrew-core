class Dispenso < Formula
  desc "High-performance C++ library for parallel programming"
  homepage "https://github.com/facebookincubator/dispenso"
  url "https://github.com/facebookincubator/dispenso/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e75b2a1bd428b2e9558ea99c03d266d2bf8881ba41689016e8c98052e1a0c17d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfa3dc2188a6867fa7e7c27cbc0761f6683f8c941a86bbc1e484626cc99b8578"
    sha256 cellar: :any,                 arm64_sequoia: "4281d2b609a86c254cbbcdbb351e603b85b70748da2954c1810781a1aeb67769"
    sha256 cellar: :any,                 arm64_sonoma:  "efb4f85c4d8aaaf96666934346cf4ee46cf000a60df21783827b85186a30f0a5"
    sha256 cellar: :any,                 sonoma:        "72c83dc6993fdd5a3fd38a0e8fab343bb774e7254157b3a8b68d047fb12a9fb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43f84d73d3c3f6febd9211ef6e9e8bed6b8a492ecdae7067be45e0f414747078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75186ae2034cfd299c92bffc56fab21abc14f800ffa07b784266a62d5331b8e"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DDISPENSO_BUILD_TESTS=OFF",
                    "-DDISPENSO_BUILD_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dispenso/parallel_for.h>
      #include <atomic>
      #include <cstdlib>

      int main() {
          std::atomic<int> sum(0);
          dispenso::parallel_for(0, 100, [&sum](int i) {
              sum += i + 1;
          });
          return sum.load() == 5050 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(test_dispenso CXX)
      find_package(Dispenso REQUIRED)
      add_executable(test_dispenso test.cpp)
      target_link_libraries(test_dispenso Dispenso::dispenso)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test_dispenso"
  end
end
