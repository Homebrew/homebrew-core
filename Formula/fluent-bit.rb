class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.6.tar.gz"
  sha256 "b38126c557b635590fb73ae8271f3f9e0bc2bd0ac46db0bdbe743e67129e226b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a8e1b2d2cba528d3a8d3bfa6e1cdc970b4c1cd9a026bf244afbdcd25dc7a8aec" => :big_sur
    sha256 "d09504ae0d5898e9c37bd69b6c6789c0dd2b9edc877352a45c4cf92a0cf79e36" => :catalina
    sha256 "bbb8b1961637515db490f813dcbdab24a4d76ea1bcf48344292d74bda072f6d0" => :mojave
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
