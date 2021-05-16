class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.5.tar.gz"
  sha256 "b27b55068d87448e6267db627e45902249aae1b83ef552be62ecf3b01eb2ef26"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "b8b1b64e8fea20dac5d7aa8f96a8d6f6321718d6c7d48710967e026bbb6e98f7"
    sha256 cellar: :any, catalina: "ea2bc8ee10b30fa19b4051ca6375fc77edf4a334db8a13fa72383b517a2c2679"
    sha256 cellar: :any, mojave:   "63fb494a86a0768058363e0ccb9b546f369f603d98539d4f8d2b058aed6aec03"
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
