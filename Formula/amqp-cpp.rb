class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.23.tar.gz"
  sha256 "699339e4f81d165d7f6842ce464df36a403d08efbae9ded8f802f152d8bd5958"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c664632a3a6d58847e0635b11095c9036fab57d9d1be2c6522bae633b3b27991"
    sha256 cellar: :any,                 arm64_monterey: "cccb7f548595cfeb394736100e555407ea89be4ba98d8395effcec1cfc6b78e2"
    sha256 cellar: :any,                 arm64_big_sur:  "d32e583ebba0a245f2bff754c4d681cfcea3d768a2fa502ed41f70c00695fcb0"
    sha256 cellar: :any,                 ventura:        "80c0f5641c0c7bed47d8d1781d94003f46f580d730ffeeaebbf2e4d37a601f38"
    sha256 cellar: :any,                 monterey:       "58bb8b6767a86f3221850ce4fc1637f0ac9427d39f5534c69eb5d9ac4380c0d7"
    sha256 cellar: :any,                 big_sur:        "5ce871a66b88d57f80954f503754e273f86b4695201a72ea83b326aaaab3baf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bdc57e60ee0048bc982af729db9d3a68f2adba79420558a36ebc8d28ead92c9"
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
