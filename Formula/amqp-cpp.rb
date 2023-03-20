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
    sha256 cellar: :any,                 arm64_ventura:  "e7e46bad0746bcb04668af65113aa3a49492b4eaf0088df9adad8a46155da19d"
    sha256 cellar: :any,                 arm64_monterey: "966fe988253aa46a75fabd3259de7d214142e7fb27f6d0b42eda7fb7b5ca53e9"
    sha256 cellar: :any,                 arm64_big_sur:  "f76cdc0992902f120f09946f5a3ac81c399d6f6d50b82c6b6f064e145dfb7578"
    sha256 cellar: :any,                 ventura:        "bb4533aa1cf64aff8f138221a9dab27eb51aa314e8071c4e48398220b4b41091"
    sha256 cellar: :any,                 monterey:       "f775925b6bf7956bf93a78c6702d46bc756580c531325811b34997d583bf4135"
    sha256 cellar: :any,                 big_sur:        "f7566541bf2a42a5c334a739a0b65009c85174a3b56e6c72da9262ca3480901b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea190ca98023a10046b97a609d875715e85b0ad925ac622e14af7eb7e7507386"
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
