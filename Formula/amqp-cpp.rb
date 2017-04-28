class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.7.0.tar.gz"
  sha256 "4668a5dab5bc0b1dda2bb1253e7c3214f6fce9f3edcf8728fad01bb6c8a29b97"
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

    # Workarounds for https://github.com/CopernicaMarketingSoftware/AMQP-CPP/issues/123
    cp Dir["include/{endian,exception,frame,protocolexception}.h"], "src/"
    inreplace "src/CMakeLists.txt", /^messageimpl.h$\n/, ""

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
