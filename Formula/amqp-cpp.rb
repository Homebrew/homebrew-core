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
    sha256 "79d5b4c3713343fca13b9b37687f760b968280fb1780f6959e1b7e1b816b978b" => :big_sur
    sha256 "cc4918e1f0d6bbe0744871e910bc80b4ad967bc7b82b86e8163d2c78f6aa3c19" => :arm64_big_sur
    sha256 "6a1aeb607f66462b09a5a346eda93dbe89fc94cb3f3dc15954a0dfcf46ab7a7b" => :catalina
    sha256 "5338cfb4208ab483b8f40505aebad5257ba97c60a20239c07374a980c0164372" => :mojave
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
