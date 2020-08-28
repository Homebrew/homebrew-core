class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.4.tar.gz"
  sha256 "dce1f6ceecfd66a352d3d01ca355f8fce728ce9c34824329a0f78818dfa06bf1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "6573c1c0dec7a13561cb1de47835c5637d574929f58d0e2612072c9a79217989" => :catalina
    sha256 "73686bea4d4f39c7948027007d8779a0773ec8751235f4367d4a8f10cf76990a" => :mojave
    sha256 "6f65e46ebb047264d30d340ee6b91230cc4afdb6cfbd19f66321054b33076f12" => :high_sierra
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
