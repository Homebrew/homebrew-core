class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.1.tar.gz"
  sha256 "7f3b8c79bb09a87630830b3701133c7a1146bde7d3ce892d709b3a287646637c"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f48312343a7d8d6386056de74a8250e259bdd96e5291974e09cfa081e405180" => :mojave
    sha256 "0e9468a9112929ad2e5af74d7b32a5097d88eebc6984712d7804da11d1ee7ebc" => :high_sierra
    sha256 "bd73276cc219acec4917433e2cfc1e423eaab910b8fa4365511e0ed86707fe64" => :sierra
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
