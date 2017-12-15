class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.8.0.tar.gz"
  sha256 "45c973fa9bcf78d9a95f9a1662d5eab9c0ede26e79725542f4e086ddcfec5645"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any
    sha256 "59eea4c77112bae85d4bdd28a2173fa26030a046fb0cd3621c8cb8cbe872bb21" => :high_sierra
    sha256 "7e8798ab7af1e516e1a230427734428445c0396d36621bc1134e8d9c68ad15ab" => :sierra
    sha256 "f0b2f7257e5082cf0e11bc12d4d93a8a2c6642aa7ee29335812dfd05740421b8" => :el_capitan
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
