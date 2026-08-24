class Dispenso < Formula
  desc "High-performance C++ library for parallel programming"
  homepage "https://github.com/facebookincubator/dispenso"
  url "https://github.com/facebookincubator/dispenso/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9641511a6b14a77f68817f1a6e72fa9e55bc3ef2628a10011dcab07c6ba10539"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1683251bb66439c05113af8b801ec85da7cafaea986a322dc03f0cab906e174d"
    sha256 cellar: :any, arm64_sequoia: "fad3b39753c1ccf1437783ab5bcde5d416d3980669fd8133d2f080b8041bf23f"
    sha256 cellar: :any, arm64_sonoma:  "4193ee973260262457af019855da0170697bdbc66ae2cbc9ade2a44494f97857"
    sha256 cellar: :any, sonoma:        "c1648469d0d8b1ade806d0230eaafb2d04bd16b45dec6bd2d8bfcf3bbea09626"
    sha256 cellar: :any, arm64_linux:   "2151910393738f931e6e5b87727c9e8f96dda2a86c0fc8e202bf8cbc440c3cb6"
    sha256 cellar: :any, x86_64_linux:  "ca370ab686b76575790531ed190070a358146ee849fce6c43635d4140a165f01"
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
