class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.19.tar.gz"
  sha256 "ca29bb349c498948576a4604bed5fd3c27d87240b271a4441ccf04ba3797b31d"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "827e422fe2c209e48d781dd11881ddb11ecabda55f06ba1095019f7e667b5d35"
    sha256 cellar: :any,                 arm64_monterey: "d6823017b0bbbddc0490d68c7a73beaa580b22bab360784baf60a4ff0d9046fb"
    sha256 cellar: :any,                 arm64_big_sur:  "ae9cf4ec980c8cc699ebb1c70a785139d26759e703324ad1df8151c90aa18461"
    sha256 cellar: :any,                 ventura:        "24ed76c164ad89e3a24e60909a85814c1ee446fec47b800bec2b41c400deb440"
    sha256 cellar: :any,                 monterey:       "32e68fbfaeee7409a6b7e8fe4dd742d4589762cb601e0800e235acb2c326e3a4"
    sha256 cellar: :any,                 big_sur:        "f0222f1ff29774ba9e39d11c92797f465cb066529cc7255e5c65f508e3ca3d46"
    sha256 cellar: :any,                 catalina:       "7b8abc464785804e5ee792e480baef60e565d4567bb6b330230ccd99e5e63473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b54f0272c3d9e660443bec29e24b785a9987835bd8c7fff4e6b6c7efaa17dc"
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system "./test"
  end
end
