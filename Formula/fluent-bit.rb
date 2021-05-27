class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.7.tar.gz"
  sha256 "ddfc4df39a1da01c5e7503db59340c3b287741b5d0cb710f94f5f7551f41c888"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "ff69f5d8efe970c1b9667b42a91f052392333910babb7071e2a74e1b198bb67f"
    sha256 cellar: :any, catalina: "0345803f857a8c16c6d7305736f1b597b9c149805366482f3b897cb56c9b4b6d"
    sha256 cellar: :any, mojave:   "0b6088ab0b5f33be13c2d3af5dfa35cbdd187372821da9a08e0366e6ed8b5035"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", "-DWITH_IN_MEM=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
