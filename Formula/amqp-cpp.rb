class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.0.0.tar.gz"
  sha256 "21357f06b8f82a77413f4b7b812cbcb58c9691e7eeae963a01e59f655c59d661"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be025df3263b5fea2fea1c1612aaac25f7be5fbee88fb70b99ff6f2eba0bcfdf" => :mojave
    sha256 "029ae5a7f3ae975655481bac058eecfc13e3d1a8f63a5585f1ee92c1c24b74d0" => :high_sierra
    sha256 "6c10eef3f932f43abd273f51c0678cc3c382e822ee1989c601185e35b36b8fa7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  needs :cxx11

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
