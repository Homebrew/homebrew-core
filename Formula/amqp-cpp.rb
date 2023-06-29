class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.25.tar.gz"
  sha256 "d4a4b89d27211ee9eb357a4d3037ae187fd8fccd74441db2cb83875173e2d868"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5bec077b55a25b9f658edb05ded0ec8dd0c39c71cf7a912d66d132269010ce51"
    sha256 cellar: :any,                 arm64_monterey: "f61915a4a0ffa6af1677523268d426eebce56fb1e0e3c6e9f708744a1ea026e2"
    sha256 cellar: :any,                 arm64_big_sur:  "2ac8614f8016b5be68ecf02d37d707d48e189e888348384f5d53a2061dbc9dc8"
    sha256 cellar: :any,                 ventura:        "ef87504ece7c46609f03a5b8ce725159b7d299376117050ea386164e9e0a936f"
    sha256 cellar: :any,                 monterey:       "e0a356a88ca754ec99a7f27846ac158214d3d565909ef5ae249df6dda30b5a23"
    sha256 cellar: :any,                 big_sur:        "c929896376a009179effe491ecde52b75d8f08479f58aa509f533033849d8a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d617f6d3449997e9a1b272673667337d191f9044bf762409d0a69c627568ac3a"
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
