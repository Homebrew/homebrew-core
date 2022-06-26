class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.16.tar.gz"
  sha256 "66c96e0db1efec9e7ddcf7240ff59a073d68c09752bd3e94b8bc4c506441fbf7"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec00a2b6a9636a99b3e164284a9d65ebdcf2293fda167647ade88fe0fcb3c61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b5227ad442f8abe8932c375d21a71047f10c585fd28e57305771cfff4cb0d22"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8f8868acd5abcaa1174a6114d4d8616e18efa54efaefb11fa356ebc94d2f6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c86f56420a57c32a03e7541ac3db1fde7c1eb60bec33100375107fd41b5b0aeb"
    sha256 cellar: :any_skip_relocation, catalina:       "8b17778d04251e140bd89b61002e11d48f18570cad294aadd19bbd24c406c49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d9aa8520cddc67a852be9cc96315daa0ebb064300acff45ea63f271fe07a27"
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
