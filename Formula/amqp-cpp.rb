class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.6.2.tar.gz"
  sha256 "1a60d900a8e32b55b39229f2ea00070156b99c0a1336450d531038e6241a4d8b"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any
    sha256 "f6a140f35b267b9cdd933da245bc822b41eb39ce9cf7728fdaf2e2b7b1cd85a5" => :sierra
    sha256 "d55ffcc984e7c28383677382523e50fd706fb7a3e61daf3f4a531fd609f80491" => :el_capitan
    sha256 "e2df5e3dd1ed00d3400addc5b79479b91e0fc34dead3b6c45b8a2aacf3f043d6" => :yosemite
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
