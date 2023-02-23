class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.20.tar.gz"
  sha256 "89ffd421cf31058a6e530cd936e487af350db1b4cc8172459fd00ea127c27c34"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43d468a1385290e82f248bad31d0655e3ea395ff47ef47d2fc389a43b34d61d7"
    sha256 cellar: :any,                 arm64_monterey: "72a92e24bb075265592b021c8c39ee6fdc1cf0d8b9fbfaec068666cae59a1c1b"
    sha256 cellar: :any,                 arm64_big_sur:  "82c4faf577c73febc31d29a72e6ba0078379ad3c8974eba34e90959083fa77af"
    sha256 cellar: :any,                 ventura:        "2eafeb6699ff9a3d5aaec844fd0016b4e4f560b30c2e93fd9c20dd522da7e5ab"
    sha256 cellar: :any,                 monterey:       "3e45a055f43706e3bcc7d3f31b16bee4cecfe4b0a8c8e1952ae15db6d8748cbf"
    sha256 cellar: :any,                 big_sur:        "6742b624c72ddb1bd2353bb3ab9d15f533085f7170926ffd68d5ccbba64084b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0518aa063464db3125d602010074798d0fecacb75344a329bcb8f858a8b4198e"
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
