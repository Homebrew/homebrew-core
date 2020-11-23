class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.10.tar.gz"
  sha256 "4fa1e9650f7a08ae7217899431a3b3f0a173ad826dd819f0b8c760e4e2a65298"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  livecheck do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "668f35e6fa88f021117081bf2f96be2ab573904473c05d11ac9df1f4813ff299" => :big_sur
    sha256 "07fe1b1c1138a53301bedcea92f759c8ca50bae23ac53059b9e679a2920bc91a" => :catalina
    sha256 "4f7245c4a10b0d53a1318f969a53edc3e35314cce0aef1b66b6b875dc57bbb09" => :mojave
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
