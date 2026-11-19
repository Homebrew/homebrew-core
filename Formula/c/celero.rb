class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c01aca0d991331e5f96804ba8e5e1abf1c4209b012a1ebe8b98df76e0478f87b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be40d5e1407b125ab2c19be1955902b2ea5dc0caaf7fc553e22784c754368491"
    sha256 cellar: :any, arm64_tahoe:       "21940873eda4962c4fb1557aba8eb735ab209152a2da91ea1659315baf9fb0a8"
    sha256 cellar: :any, arm64_sequoia:     "9fbf5364ce367a1e306c563e502d69d4f3580f08c567ff2205eaff6e8e4d0f81"
    sha256 cellar: :any, arm64_linux:       "f33325a371c3b3084ff1a51e6aff833599056a0f0208e7a89aeaf13a3e386e88"
    sha256 cellar: :any, x86_64_linux:      "716af80343ef929d49f081f6d7f5eeab8526cebd262a3ce0b1d4971ececc6107"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DCELERO_COMPILE_DYNAMIC_LIBRARIES=ON
      -DCELERO_ENABLE_EXPERIMENTS=OFF
      -DCELERO_ENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lcelero", "-o", "test"
    system "./test"
  end
end
