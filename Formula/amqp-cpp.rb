class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.1.tar.gz"
  sha256 "7f3b8c79bb09a87630830b3701133c7a1146bde7d3ce892d709b3a287646637c"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7172d5a5f3585e231b63ab4ea2b3a32ab4c33cf2989cc0a73a4717653707007b" => :mojave
    sha256 "5ec6fa14ac6d1468872a9552b8456fab8ff3178d830c642ead8ed97b778cdf94" => :high_sierra
    sha256 "75a1a1e1156bdbd01f325787938e81c2e43d9483afd427fbfd60d8742c758fbd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    *std_cmake_args
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
