class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "c857d1fa7b20943bcec78ae043686cf77c9447d72537d8d2ba142531bfdc8fad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8ca29a93a9121f3b3753d3489bce47b34c9466131283e79eb7056bbad5d898a"
    sha256 cellar: :any,                 arm64_sequoia: "32c259b5e2ceb2ea4ff8ef5a327c8d133bbb5aff95c64636c1adcedab2ed5936"
    sha256 cellar: :any,                 arm64_sonoma:  "acde51368a04ee57318cf5624248db326858806a426505feaa15b17964235406"
    sha256 cellar: :any,                 arm64_ventura: "c4d45dd58e34abae054e11fb16505fed2c1401c367ac79c0e055f19d6afa50f5"
    sha256 cellar: :any,                 sonoma:        "0fcf1555bd7ec8845edcb9365b0b4c8dd72a0559dd6b4b6875be2a624a951971"
    sha256 cellar: :any,                 ventura:       "a231fb0188c070c3f56194cdca30804bd02d4a7cbd573470fcb58a0de9286dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89551d7946653975b6474506e1169006a32dd276ff6d36caf0c2c601cb39430f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06957574cf0c8ea5e37d6a2c6fa4b67398faab55dfead8964f439de11ca0c3a2"
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
