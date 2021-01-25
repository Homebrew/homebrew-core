class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.11.tar.gz"
  sha256 "be2b11ada1020f77b859857310be54bd073c3a4f579d99a5e251a738576ca28c"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1442f286a2b310a52bb50fe96a3a7ed9c0195d5ce56c6b57d6bb113622e08798" => :big_sur
    sha256 "754684e971db63046c2ba2aae19a4a2d6b0e33b18e07aa7ee324b9df5fd6c8ad" => :arm64_big_sur
    sha256 "1360b3ab9cdd7a8deed94088bbfaf3851ff505f2f395e407ea80ae3526d3b3fb" => :catalina
    sha256 "9a18301146ab0ea720276fdc838f00841e1c3ea9a80dd2688ff6e1c054432c99" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

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
                    "test", "-lamqpcpp"
    system "./test"
  end
end
