class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.1.0.tar.gz"
  sha256 "0569fde9571dbbdcfab90550e602e771f9a8b2c5f62c85e089ed5cebdf1cfaef"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fff3c0a21ba3f19ec483393558652bcdf6461434e6249f0673cfb73ee5410e53" => :high_sierra
    sha256 "344bdb630b7a7057a3700c1352e0603be758b0a91616f019158de5db5e148509" => :sierra
    sha256 "ec28e43d57fc02de7d858d26be7b286e3b6e9d6b514e6b4228945f685e454fc1" => :el_capitan
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
