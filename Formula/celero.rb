class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.8.5.tar.gz"
  sha256 "1f319661c4bee1f6855e45c1764be6cd38bfe27e8afa8da1ad7060c1a793aa20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "891a06f829ea99aee218982f47565a1fcb7f6defddfa99ab7b7f1b1406b98341"
    sha256 cellar: :any,                 arm64_monterey: "9faafd868553279a8d9a5aae01e4ba266f6bfd8d3b9dc7337f58020adc640e1b"
    sha256 cellar: :any,                 arm64_big_sur:  "0995452e8eb6407a4c5d27592e29afc2e2d693ce2becbb620d9cf2d526d5286d"
    sha256 cellar: :any,                 ventura:        "bd6fad1cbe3035497c996d76a6e94046bfa75b95cfb61f1b08049d66321e7751"
    sha256 cellar: :any,                 monterey:       "a99ed5cbcd424938d8134da663041a99274a36cb7aa55daca22d64f92348d5ae"
    sha256 cellar: :any,                 big_sur:        "7fac55643674044a98f385957dd36c31917d8012ecea7bce57f5fec4b6e5db4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f7d5cf83fdc9ca6fe95d1346c6593e92dc3a3e03e188d9ca9a69a57e14e5a5"
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
