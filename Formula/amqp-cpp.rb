class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.1.0.tar.gz"
  sha256 "0569fde9571dbbdcfab90550e602e771f9a8b2c5f62c85e089ed5cebdf1cfaef"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5a4906dffff5ecb0f0d45632899265570e7f2373e209961a6f1626fa565aaec" => :high_sierra
    sha256 "583b0b59abfc32c64210f95c9c3e90bd5be566495caa0195b9d05c75b02444ad" => :sierra
    sha256 "38fbb7f0df51723d2b2d31bfe83a2348362c1d688b50011a99e6ccdbee2ba774" => :el_capitan
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "openssl"

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
