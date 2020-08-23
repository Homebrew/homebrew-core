class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.4.tar.gz"
  sha256 "dce1f6ceecfd66a352d3d01ca355f8fce728ce9c34824329a0f78818dfa06bf1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "eba66538e9a02b1089e1821a6feef8b78a72ebbd363fdfa43001541395747a63" => :catalina
    sha256 "d2c96c19c4e91add1588b2079448ace97d7f18a41f97f8bb0d7169da8897a99f" => :mojave
    sha256 "fa0f26ed0282fb8231813d717cfcc05bdf4bfadee73232ead880af09188b4438" => :high_sierra
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
