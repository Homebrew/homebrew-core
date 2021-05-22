class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.6.tar.gz"
  sha256 "580c539cfcf9938cdbe24cfe2e5cb793b7a2cb59ec7f222eabbeef2a89816829"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "dd195035cd03ad816c594a42d9c9a994e5ec63885e64e9f8a116230dc22e7e9d"
    sha256 cellar: :any, catalina: "1d0af80417663d414b304d44bc46ee64fea28dfa106ea23265533869c928492f"
    sha256 cellar: :any, mojave:   "833f4bd303616b62807640203fa8b2277d4b204080c48f5b803b7d773c659aa8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
