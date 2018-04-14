class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.0.1.tar.gz"
  sha256 "8fe0c6a6eea09abc0ba619cbc66d092f2537de5dce8f5868d7fabcdb040752ed"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9680761f8320e20b1bd536fdee1d0a2a2d30444698884ba29aacaf923f8fff4b" => :high_sierra
    sha256 "1012d39453b259fc94718bfa004c9554b67bd46bcb0b6b07879c54ddc315bb01" => :sierra
    sha256 "46253976be6dc785f48aa5df07848de1e4dad58c465280bdbc221fdb054d7796" => :el_capitan
  end

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON", "-DCMAKE_MACOSX_RPATH=1", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lc++", "-lamqpcpp"
    system "./test"
  end
end
