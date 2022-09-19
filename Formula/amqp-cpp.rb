class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.18.tar.gz"
  sha256 "cc2c1fc5da00a1778c2804306e06bdedc782a5f74762b9d9b442d3a498dd0c4f"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff2d7a54df33bf1ec13c773a9714f63751b32fd2e30dac53e3dd96c040f86c59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6771e28f8bf4e2a82103e4d546b5f5e3330defb5fc6181d96f67555900094701"
    sha256 cellar: :any_skip_relocation, monterey:       "144f87760489d917765495730f434c374d00a9a22f9c77a604d94b32266bd408"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c573a61befb1eff39e68b81800dcf78a5b232271e3f1c164420a68c12ef085"
    sha256 cellar: :any_skip_relocation, catalina:       "4a7803c5420d64e98f60b56cd9521382942b284502cae7a499b92a38fce3b6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64169d2c9dd1ca845eecaca7cb67d09b60cdc7fe6ff263fa4350c2a8c52f6fb6"
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
                    "test", "-lamqpcpp"
    system "./test"
  end
end
