class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.8.0.tar.gz"
  sha256 "45c973fa9bcf78d9a95f9a1662d5eab9c0ede26e79725542f4e086ddcfec5645"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any
    sha256 "44278c917e59878edd3cff2a79ed6a94cc79fe778ac32f20d20f7b015526e05c" => :high_sierra
    sha256 "b1d85c9445970422250b5b91b70410f1ecc2b9c3951ea5cc5b323cd7a1eae96e" => :sierra
    sha256 "318296f5c2379e06200f55c3c4a30b222ba03aa0e5be25b900e5c306cb7785b7" => :el_capitan
    sha256 "19332e146a7c45fc9129661d42ccaa4007d56e2fe56a4638b5e0dbab094bbe3c" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON", "-DCMAKE_MACOSX_RPATH=1", *std_cmake_args
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
