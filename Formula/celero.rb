class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.8.3.tar.gz"
  sha256 "b87e3b3c5871b9c88b474340970c7e3fa5431cd327b6bbc399594132f8f99bd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9536a9809658935372c9d818c341e54c3c0f7f1da7f2485bb7bf9a5f2fddfd0"
    sha256 cellar: :any,                 arm64_big_sur:  "6952842a85eed42b08c60a05c2c18b965da6278c00f052b3c791be9d1823beb8"
    sha256 cellar: :any,                 monterey:       "d17d2c1673e4fde2a2ecc5c44d636df7768b5f0f2e01d9feb0f3f118934c7631"
    sha256 cellar: :any,                 big_sur:        "b3dedb5a019ab39ee9bbc122e56cdff8db779cc381a14234c8fb3655c9c4af02"
    sha256 cellar: :any,                 catalina:       "2c0a33b10ba38244329606dbad5f2a959897cd6bed759fbbf554d9152271fabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0caa8d4ef722ca17eb9d23e951ed2600472f1ec6793077570effd667194174b"
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
