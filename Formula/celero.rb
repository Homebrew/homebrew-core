class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.8.2.tar.gz"
  sha256 "7d2131ba27ca5343b31f1e04777ed3e666e2ad7f785e79c960c872fc48cd5f88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "168316f993a6c863544a016792a1e63bd81217d3eae23127c68fcd43efc61742"
    sha256 cellar: :any,                 arm64_big_sur:  "5e453112cc93f023024275cd8987a54a38a970d3c71cbde50518548e8ccb062a"
    sha256 cellar: :any,                 monterey:       "9b0402f09f2ffb96cb3450ca00883802a6bbd38687af45578f52982d2318f4c3"
    sha256 cellar: :any,                 big_sur:        "a0540747a66aac50656e7c56e0dc6fda639c07ccb75586303e521059b6378cd0"
    sha256 cellar: :any,                 catalina:       "2086ec944df34368a864da280c66fdca1c12cccc4ba462b92a6ccb8366a6e27a"
    sha256 cellar: :any,                 mojave:         "8488e63e928c80c3dc1dcb276c888fb198f08df8e54797326a8e25c70e807949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f0d2de85eeb4efe40a955a9e2de59f08fa13d29eedbb7beda7e8ff6fcc05806"
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
