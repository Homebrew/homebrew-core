class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.0.tar.gz"
  sha256 "52129e83cce417d48f670b6012f53a505c3ee7f904e0c0f75535516194b8dbb4"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dc05699f0abb8e845c41834eda1400f2f2c680657e23900d18a099ba61542ff" => :mojave
    sha256 "49705f3ab7b6ad81e9b7356ce9be58387151b35d083f91a36c1b793972b34972" => :high_sierra
    sha256 "07295fc11cc21f05e618438174b6751fdfbe5a9f72b55dc8a4f03d0cfd71d083" => :sierra
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
