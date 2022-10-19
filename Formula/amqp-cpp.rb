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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24381f122082f6bc71d6d823e4d4088098d03cd5486ad8631beceae877143f91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6570402e4fcb471725af08d828a55470018386eaf5c2badc105cfa0643618e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "d8025764de7d9ad20c80c85565d9295d4a8d9cff203d047ef1ce0ec875ab202d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6170e84af0035002784f2ac2cd88d8c69c22899770ec5adf6cb46f03626be27f"
    sha256 cellar: :any_skip_relocation, catalina:       "5af125ed68bedeccf437ad673aab47fc598417598c6bfe212070b1ff99c2ba42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b397a9408cba27557e45674560c0191f8ac31115b620db2e7b4b539c55067a52"
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
