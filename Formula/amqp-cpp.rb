class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.6.2.tar.gz"
  sha256 "1a60d900a8e32b55b39229f2ea00070156b99c0a1336450d531038e6241a4d8b"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", "-DBUILD_SHARED=ON", "-DCMAKE_MACOSX_RPATH=1", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lc++", "-lamqp-cpp"
    system "./test"
  end
end
