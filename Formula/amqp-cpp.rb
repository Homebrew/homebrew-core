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
    sha256 "7ac83ccaae984ecc6fbd138b417c7613a87049bf15db87bddeb359a9c6168e6a" => :big_sur
    sha256 "00227c782b9b369d8789d4287c4d174d5dbd2e4e646b159de44c35d151130565" => :arm64_big_sur
    sha256 "04110248cacbc6f2139945936635906e3225a8ca69f2481774c3f23f9918707a" => :catalina
    sha256 "5c90bc9289b6de7c8f7604ee67767cd8df2629b8657bce2652d26d96e812cddc" => :mojave
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
                    "test", "-lc++", "-lamqpcpp"
    system "./test"
  end
end
