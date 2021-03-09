class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.7.2.tar.gz"
  sha256 "91ba6071043427b1073857c20a81175a9272901821e39b16c6c0b053eca7c992"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "908150104140b55b3c826df16e6463b69176e77a8a4f9c82440e3cbd9ac6500a"
    sha256 cellar: :any, big_sur:       "2229a4bc8f706b71c3ae4a1558127cccd63eea1920cc4cb7f5c619915adb70b5"
    sha256 cellar: :any, catalina:      "dca2529b3a0e1aaf3c1dbb4239d2d34d04a9f2b1eb5395b05dbed54e99c013aa"
    sha256 cellar: :any, mojave:        "7d6bd55420330e44c238d8a14cc3b5e95ecac82a1dde6d20e7c9f6ce3f95ab72"
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
