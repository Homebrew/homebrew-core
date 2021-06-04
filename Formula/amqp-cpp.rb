class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.12.tar.gz"
  sha256 "0a927532ec3869004e4baffc264e65c3f8a0ae2846ee1f7ac60478c760487d36"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e63fe2e0fc7f090bf5c1cfd3bbe0be4f882b6bed5370c380664cbf830bcc820"
    sha256 cellar: :any_skip_relocation, big_sur:       "333179f73aa48640012f917e74d4a81ba2b5bec984aa4891be8b250659e39900"
    sha256 cellar: :any_skip_relocation, catalina:      "10705f95a5801071dedc5aa540dbdd4ddd7760828af1d8a9d6893fb23f5f27aa"
    sha256 cellar: :any_skip_relocation, mojave:        "7d73220c151d2a9565d126492cf82d9d8849d82dc9323557d97a0f0ce01d6823"
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
