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
    sha256 cellar: :any, big_sur:  "061cd1482bfae2d3b6615a93f03709e6350931d07b770cf76048cefe949e7433"
    sha256 cellar: :any, catalina: "491202ed9c8537ee96d5988abf507622b9ed55572315dfb80f3bb15cd4d044db"
    sha256 cellar: :any, mojave:   "2985f5622ffc0c65fcc7b38be43f7c57808313a017d83ef6bec08e3536981464"
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
