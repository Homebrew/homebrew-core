class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.9.tar.gz"
  sha256 "e577b39ed178cf7b8c678e0c4cd00058f2b64b225b08d7f241e229c9cc407636"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  livecheck do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "275f213084c4509dcd45d557481847ff12d9f7c0bfb0ee2347645e4357adb91b" => :catalina
    sha256 "1bb56145a2d80949f3584b4a6b23b120b35c220b355f1e47fead09e5a2d2269e" => :mojave
    sha256 "075fa09056e450157fea748b62dbefca028a9b712fef988f034eb7af58a644d1" => :high_sierra
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
