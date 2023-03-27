class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.21.tar.gz"
  sha256 "173b054ad2fe909538d99975bbff9f1aacb3aa30442a22361892ed8826e2f586"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d055ba679b1d2ffc792d51e9c26a477fe08f70fd3e0492648589b0d9636a951"
    sha256 cellar: :any,                 arm64_monterey: "b399dab6b504736688b38a6b476e35231327f74656f7277ffb6c0ed0b33e0ec2"
    sha256 cellar: :any,                 arm64_big_sur:  "b17207e3d99f441e544fcf74b6a55b6a46c6a3a981e8709e1c40904f683f7a0e"
    sha256 cellar: :any,                 ventura:        "b9f14c0ce123cfb44ae3c4f09ee8e2ce9ea95e01847b0eda47ae6f8dbfda5adb"
    sha256 cellar: :any,                 monterey:       "47b6f16474e3ff7b686d57e35043ed7fe0c0e486da6269a3c2144a01614d71ce"
    sha256 cellar: :any,                 big_sur:        "b42dc48ec33206154316149112e423a411d6e2b5fd62861cf35003672efd0a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ea468ecfeb0e7d0ede5249e58b1ece7d580223885f4167674049dc0085cc0c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DAMQP-CPP_BUILD_SHARED=ON",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system "./test"
  end
end
