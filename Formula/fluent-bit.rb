class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.2.tar.gz"
  sha256 "732c293b588d8c1ff7cc4bffb0b671247f9b743adc28562cf39a485f590cbf3c"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "603cb62859535f526ebc25bd79feeec2dffd80c4034bf5233b37ef4154446a69"
    sha256 cellar: :any, catalina: "3eef292b1db3805d2dae6a9190147682f9e6428f7e136cbff6623edb746df367"
    sha256 cellar: :any, mojave:   "8f16be3826e994e684094d549a5142f328daa422c2d0da50e36085e32da9f029"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

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
