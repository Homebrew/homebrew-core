class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.5.tar.gz"
  sha256 "9840c7fb17bb0c0b601d269e528b7f9cac5ec008dcf8d66bef22434423b468aa"
  revision 1
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d93feb5299d503a2efc1fa6198e48e41f277f3ac6fbfe3af320cacab40fcd6" => :mojave
    sha256 "afb26fb7f804bae1f69bee3503a0aab8c309a3890390edcf8dfb937a93f0e7dd" => :high_sierra
    sha256 "82f558d90a65e85d50ae4dd835cbdf77571558fd45e4fe31bb694f34db6124bc" => :sierra
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
