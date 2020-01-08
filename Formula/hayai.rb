class Hayai < Formula
  desc "C++ benchmarking framework inspired by the googletest framework"
  homepage "https://bruun.co/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v1.0.2.tar.gz"
  sha256 "e30e69b107361c132c831a2c8b2040ea51225bb9ed50675b51099435b8cd6594"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a63325782e38d9ea125ec2948604856a2d0a95a89607bbe3eb8730ca5034009" => :catalina
    sha256 "083c25ed21eb21a54f72ea2957b47e6444278aaa996143c2788e434fb19eaf0c" => :mojave
    sha256 "c28fb50fbaed6281dafa6b8ec7b2cafc45fe3255bcc57a6678dbac5da67e4dca" => :high_sierra
    sha256 "d2702e169ba0c8a8b79f3df6f83fc2268b95b0b0d2c2c4d11387ea99011800f4" => :sierra
    sha256 "0a9089377b36a1f719966add1fcd01780e27e250db062affb818236e9b8161c6" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <hayai/hayai.hpp>
      #include <iostream>
      int main() {
        hayai::Benchmarker::RunAllTests();
        return 0;
      }

      BENCHMARK(HomebrewTest, TestBenchmark, 1, 1)
      {
        std::cout << "Hayai works!" << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lhayai_main", "-o", "test"
    system "./test"
  end
end
