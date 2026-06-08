class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/refs/tags/v4.3.27.tar.gz"
  sha256 "af649ef8b14076325387e0a1d2d16dd8395ff3db75d79cc904eb6c179c1982fe"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e45212f8e035ad4f6e765889bb949bcf8f60fef844b0646eb7006fad0b959605"
    sha256 cellar: :any,                 arm64_sequoia: "2f0ec346eb00e3280870884df2cb742dab7b834a3a1135ea566d57717c65ea5f"
    sha256 cellar: :any,                 arm64_sonoma:  "c15637ad6b4fe3af89f006ea4fb6ee9ea3a412723ce407bb10c5cb5f0de8f2f0"
    sha256 cellar: :any,                 sonoma:        "a2675cb6a8ee1b421da6bbcb903868014aee17270a5a634fcbc39b4ac9473715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f0d0088d8c57a1d507dd2c249610cbc71439276ac7dfdd6aca04c59322841c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10421912a7018eaed19fb9701b6c2aef0af19e9bd654ddf24fb0ccfd30a60b83"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  # Backport fix for CMake 4
  # PR ref: https://github.com/CopernicaMarketingSoftware/AMQP-CPP/pull/541
  patch do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/commit/3a80a681ec258807c24f54214a3b6c7fc0dc28c0.patch?full_index=1"
    sha256 "70337b274251cfe890ecf560109d7389e43ae44fb93b43f1279871aa9aa7f139"
  end

  def install
    args = %w[
      -DAMQP-CPP_BUILD_SHARED=ON
      -DAMQP-CPP_LINUX_TCP=ON
      -DCMAKE_MACOSX_RPATH=1
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system "./test"
  end
end
