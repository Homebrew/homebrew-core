class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/refs/tags/v4.3.26.tar.gz"
  sha256 "2baaab702f3fd9cce40563dc1e23f433cceee7ec3553bd529a98b1d3d7f7911c"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "74e1edc0a534f527c3f9cfa5dcedc1a21f1d6c37220887ad03bd48c686c06ae4"
    sha256 cellar: :any,                 arm64_sonoma:   "7a65fc4786cbc69389a293510b277cfeb36c168f049053f290f59f1e45d77f58"
    sha256 cellar: :any,                 arm64_ventura:  "f65f76531ab89061aed98f55056ef7a920dd3368d8d738c0615b9d52956745ce"
    sha256 cellar: :any,                 arm64_monterey: "29327632ff96b7dd4cf5721039ad8001ab758f14a528f6b0ca7cb4ee37740ff8"
    sha256 cellar: :any,                 arm64_big_sur:  "065b8751feca819dd49671549d29f038bf41d59076b60ff53aa36da2b974eeae"
    sha256 cellar: :any,                 sonoma:         "ab4ca6c2e6805e7447b569541e22452400be0f9133c4cc995993d9e4936eaf48"
    sha256 cellar: :any,                 ventura:        "7ddb6e8142b7f99ea479a274a21c2e75a0317f1dc48d895744e1b3d396192173"
    sha256 cellar: :any,                 monterey:       "a717607eb6c8014424dad81ecb9e5e55926800a32a2855e6b666bee9f2800dc1"
    sha256 cellar: :any,                 big_sur:        "1a0b91a113adaaf303a4187051af2f49f52bbedfa84ae5a672be63158f332c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f42f6efd8ed844adc09fa2d7b226c9d955c7e681527fe7d941926dc7c7098b"
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
