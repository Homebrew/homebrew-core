class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.2.0.tar.gz"
  sha256 "82b9a15fb4b2b7d53767e93065f82a068a23dbac43b76c5e6cc8b132a3db68fc"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "488424cef44d605e575206b788d60e1eb3a9df240c7b1504828cc53e3fe5b3ca" => :mojave
    sha256 "235ef391045881aa4e9c7b1191fa064c349dc94b01b1ff64c4534cf872f24666" => :high_sierra
    sha256 "3a2c0c31b834e95559da0cc078307185813b57cccfe164bb2440ea0485323232" => :sierra
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
