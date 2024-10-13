class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "d59df84696e0dd58022d2c42837362c06eba6d1e29bac61f7b3143bc73d779e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8df764c6550e49e740ac10d19e1dcfa18708fac66695b00ffeb724eaf2d798d4"
    sha256 cellar: :any,                 arm64_sonoma:   "a623447721e67bc374800d2c048c9c65fdba7fe06a21ea497a5adba2905157ff"
    sha256 cellar: :any,                 arm64_ventura:  "6c5aa0d8b749c0ae1a99501d00026676de190997457820798992145237268783"
    sha256 cellar: :any,                 arm64_monterey: "f3c479a0f6ab3d2d366bae855864122e04cf21627b000a395fbb68fb1f44366c"
    sha256 cellar: :any,                 arm64_big_sur:  "d6566ee0ac67ff7c0970df553b971fc626c02e70ad106dc2d44e88905562af4f"
    sha256 cellar: :any,                 sonoma:         "dffd38a438568728d366fe4b5ddc943c6023c247742f146c3afc7d492b94153b"
    sha256 cellar: :any,                 ventura:        "42ef19078dce4acd6d50aa076308fff7910e06355c0a8eea600e1832fd86a87d"
    sha256 cellar: :any,                 monterey:       "6011c0b09373fb45f77460bb8b3019f4124748f53007dae89421e0c801d9b6b1"
    sha256 cellar: :any,                 big_sur:        "5092b4825085f08851008b0f776942ad17629900a485e825778a97599b5793c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d360871cfd166555c2d16b0841b4669c0755532da2970bab216f7f9524596a5"
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
