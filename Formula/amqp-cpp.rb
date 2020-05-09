class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.7.tar.gz"
  sha256 "71b504f21f62b69c76b371fe7044e0dfc6d42650a15c267431c5084badb0ade7"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84f13f89f0c3818f282f66e3ad9365ff464c5eba4066da2133f687abf1677705" => :catalina
    sha256 "244a08342ea6bd03c377688f493e67b40f96d72d47013396b5eb47480e6a9fd1" => :mojave
    sha256 "4ac85cf431a531455c8ef43859dd14f93f013e89200fdd0f458d55447ee6b929" => :high_sierra
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
