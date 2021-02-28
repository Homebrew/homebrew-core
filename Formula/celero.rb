class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.7.2.tar.gz"
  sha256 "91ba6071043427b1073857c20a81175a9272901821e39b16c6c0b053eca7c992"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "172022ff85ceec2db0feb3262c386b42443cd86e949b5adf86bc60798e2770d3"
    sha256 cellar: :any, big_sur:       "d76fc6d4a0ba0fb2537a17fca23b05721ffbcbc26c7a1d5f1063f11cff1b481e"
    sha256 cellar: :any, catalina:      "848bc96ef8502281172ce61623b68027c3f08091341abd465e9e08c4ba4f4179"
    sha256 cellar: :any, mojave:        "0ff67096c349b4fde63641a65fd68149e048fd720b1da2b3c6b2fd4dd79d39d0"
  end

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -DCELERO_COMPILE_DYNAMIC_LIBRARIES=ON
      -DCELERO_ENABLE_EXPERIMENTS=OFF
      -DCELERO_ENABLE_TESTS=OFF
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <celero/Celero.h>
      #include <chrono>
      #include <thread>

      CELERO_MAIN

      BASELINE(DemoSleep, Baseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(10000));
      }
      BENCHMARK(DemoSleep, HalfBaseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(5000));
      }
      BENCHMARK(DemoSleep, TwiceBaseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(20000));
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lcelero", "-o", "test"
    system "./test"
  end
end
