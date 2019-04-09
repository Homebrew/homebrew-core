class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.4.tar.gz"
  sha256 "1e0d070d980e44a2293a94c416b5690ffc529e0246cc2ef079dec59773b9708b"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb076c768a5191f56b8479502af030015e5873a89aa8dbe669b085b6fa117341" => :mojave
    sha256 "999b517ddf39d4d81ae449ae284aca5e1e3c7bc5f32ee4ea4e59d5c4e1ddc649" => :high_sierra
    sha256 "080cc16fd0a1477767b65c24aaa27ff7f4e6cd6bc60cde1ec412b1e1cd09691d" => :sierra
  end

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
