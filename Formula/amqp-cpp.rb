class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.1.3.tar.gz"
  sha256 "138dae10c5c78382798b697afcfaad0f8c02898a91e1d61ece06d5bad3d69c3f"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e85df9f4ba93296155f037f551e2d77141c9630cd14eed3a3c151fd2bc7df9d6" => :mojave
    sha256 "b9975e464e1116233e2d2dcdf97971a53e5d117f06e910b133ef59205f6e5ed6" => :high_sierra
    sha256 "1f217794de557f20327a6b819965f9e5215adb41665c6d2caf4c0f8df90d9a76" => :sierra
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
