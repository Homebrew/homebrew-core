class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v2.7.2.tar.gz"
  sha256 "7842cbc5db7379fd60dddfe72e43d013f84a10770808b7206f0181aa7e96239d"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any
    sha256 "7e1e58e38329b1eac48b856baa745aef0e7de27ce7655f8dd2d3737ca962b5b1" => :sierra
    sha256 "8c7347f29d6551f2e0df7df589d0f00a1355d71d63b68a1ac1ca3c2cdcc4c4a1" => :el_capitan
    sha256 "a9d492c43777a18c53ba4acc7781c7340edf9f5057365a46378cdb2cd4cf1c3b" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lc++", "-lamqp-cpp"
    system "./test"
  end
end
