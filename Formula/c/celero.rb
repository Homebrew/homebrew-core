class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "166f73a1f450396238074c7444e3295082bdda875355c62e1863af12a83be8fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b63fcdb9e0f73ce01496f71df726bea56a88701a1d37a0fb79325d7fa8e71592"
    sha256 cellar: :any,                 arm64_sequoia: "70f445ab1c256b1c9697ec1713d706c84db9a7cde69fe79c674a5e6bf9f256c4"
    sha256 cellar: :any,                 arm64_sonoma:  "1b7ec357933948d2531d1426633e54ec66fbe912e7f133a11ecbb613eb74c339"
    sha256 cellar: :any,                 sonoma:        "485ca90b69b9e2e21ed153ad95a446115644398d70747325314634b86456fc02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f284e3f2349116d41cfdd37bb458b9e571ed8efb6bfbbfb688fde60e2730e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136a58bbef1ef017188b851cfaf5cf02ed4af629f3a35cf14f46708ddc314f84"
  end

  depends_on "cmake" => :build

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
